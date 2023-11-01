import * as THREE from './three.module.js'
import { GLTFLoader } from './GLTFLoader.js'

 
class Modelo extends THREE.Object3D {
  constructor(str,posicion,color) {
    super();
    this.clock = new THREE.Clock();
    var that = this;
    var loader = new GLTFLoader();

    this.esAndando = false;


    loader.load( './robot.glb', ( gltf ) => {

      this.andar = false;
      this.girarDerecha = false;
      this.girarIzquierda = false;
      this.saludar = false;
    
      // El modelo está en el atributo  scene
      var model = gltf.scene;
      // Y las animaciones en el atributo  animations
      var animations = gltf.animations;
      // No olvidarse de colgar el modelo del Object3D de esta instancia de la clase (this)
      console.log("color de " + color)
            var Material = new THREE.MeshStandardMaterial({ color:  color, roughness: 0.7, metalness: 0.1 });
            let Model = gltf.scene;
            Model.traverse((child, i) => {
              if (child.isMesh) {
                child.material = Material;
                child.material.side = THREE.DoubleSide;
              }
            });

      


      that.add( model );

    
     // model.position.x = posicion[0]
      //model.position.y = posicion[1]
      //model.position.z = posicion[2]

      //console.log(model.getMaterial);

//       console.log (animations);
      that.createActions(model,animations);

      // Se crea la interfaz de usuario que nos permite ver las animaciones que tiene el modelo y qué realizan
    }, undefined, ( e ) => { console.error( e ); }
    );

    this.lookAt(0,0,1);
  }

  getColor()
  {
    return this.color
  }



  
  // ******* ******* ******* ******* ******* ******* ******* 
  
  createActions (model, animations) {
    // Se crea un mixer para dicho modelo
    // El mixer es el controlador general de las animaciones del modelo, 
    //    las lanza, las puede mezclar, etc.
    // En realidad, cada animación tiene su accionador particular 
    //    y se gestiona a través de dicho accionador
    // El mixer es el controlador general de los accionadores particulares
    this.mixer = new THREE.AnimationMixer (model);
    //console.log(this.mixer);

    // El siguiente diccionario contendrá referencias a los diferentes accionadores particulares 
    // El diccionario Lo usaremos para dirigirnos a ellos por los nombres de las animaciones que gestionan
    this.actions = {};
    // Los nombres de las animaciones se meten en este array, 
    // para completar el listado en la interfaz de usuario
    this.clipNames = [];
    
    for (var i = 0; i < animations.length; i++) {
      // Se toma una animación de la lista de animaciones del archivo gltf
      var clip = animations[i];
      
      // A partir de dicha animación obtenemos una referencia a su accionador particular
      var action = this.mixer.clipAction (clip);
      
      // Añadimos el accionador al diccionario con el nombre de la animación que controla
      this.actions[clip.name] = action;
            
      // Nos vamos a quedar como animación activa la última de la lista,
      //    es irrelevante cual dejemos como activa, pero el atributo debe referenciar a alguna
      this.activeAction = action;
      
      // Metemos el nombre de la animación en la lista de nombres 
      //    para formar el listado de la interfaz de usuario
      this.clipNames.push (clip.name);
    }
    
  }
  
  createGUI (gui, str) {
    // La interfaz de usuario se crea a partir de la propia información que se ha
    // cargado desde el archivo  gltf
    this.guiControls = {
      // En este campo estará la list de animaciones del archivo
      current : 'Animaciones',
      // Este campo nos permite ver cada animación una sola vez o repetidamente
      repeat : false,
      // Velocidad de la animación
      speed : 1.0
    }
    
    // Creamos y añadimos los controles de la interfaz de usuario
    var folder = gui.addFolder (str);
    var repeatCtrl = folder.add (this.guiControls, 'repeat').name('Repetitivo: ');
    var clipCtrl = folder.add (this.guiControls, 'current').options(this.clipNames).name('Animaciones: ');
    var speedCtrl = folder.add (this.guiControls, 'speed', -2.0, 2.0, 0.1).name('Speed: ');
//     var that = this;
    // Cada vez que uno de los controles de la interfaz de usuario cambie, 
    //    llamamos al método que lance la animación elegida
    clipCtrl.onChange (() => {
      this.fadeToAction (this.guiControls.current, this.guiControls.repeat, this.guiControls.speed);
    });
    repeatCtrl.onChange (() => {
      this.fadeToAction (this.guiControls.current, this.guiControls.repeat, this.guiControls.speed);
    });
    speedCtrl.onChange ((value) => {
      this.activeAction.setEffectiveTimeScale(this.guiControls.speed);
    });
  }
  
  // ******* ******* ******* ******* ******* ******* ******* 
  
  // Método para lanzar una animación
  // Recibe:
  //  - name   : el nombre de la animación
  //  - repeat : si se desea una sola ejecución de la animación (false) o repetidamente (true)
  //  - speed  : la velocidad a la que se moverá la animación (negativo hacia atrás, 0 parado)
  fadeToAction (name, repeat, speed) {
    // referenciamos la animación antigua y la nueva actual
    var previousAction = this.activeAction;
    this.activeAction = this.actions[ name ];
    
    // La nueva animación se resetea para eliminar cualquier rastro de la última vez que se ejecutara
    this.activeAction.reset();
    // Se programa una transición entre la animación actigua y la nueva, se emplea un 10% de lo que dura la animación nueva
    this.activeAction.crossFadeFrom (previousAction, this.activeAction.time/10 )
    // Hacemos que la animación se quede en su último frame cuando acabe
    this.activeAction.clampWhenFinished = true;
    // Ajustamos su factor de tiempo, modificando ese valor se puede ajustar la velocidad de esta ejecución de la animación
    this.activeAction.setEffectiveTimeScale( speed );
    // Ajustamos su peso al máximo, ya que queremos ver la animación en su plenitud
    this.activeAction.setEffectiveWeight( 1 );
    // Se establece el número de repeticiones
    if (repeat) {
      this.activeAction.setLoop (THREE.Repeat);
    } else {
      this.activeAction.setLoop (THREE.LoopOnce);
    }
    // Una vez configurado el accionador, se lanza la animación
    this.activeAction.play();    
  }


  fadeToAction (name, repeat, speed) {
    // referenciamos la animación antigua y la nueva actual
    var previousAction = this.activeAction;
    this.activeAction = this.actions[ name ];
    
    // La nueva animación se resetea para eliminar cualquier rastro de la última vez que se ejecutara
    this.activeAction.reset();
    // Se programa una transición entre la animación actigua y la nueva, se emplea un 10% de lo que dura la animación nueva
    this.activeAction.crossFadeFrom (previousAction, this.activeAction.time/10 )
    // Hacemos que la animación se quede en su último frame cuando acabe
    this.activeAction.clampWhenFinished = true;
    // Ajustamos su factor de tiempo, modificando ese valor se puede ajustar la velocidad de esta ejecución de la animación
    this.activeAction.setEffectiveTimeScale( speed );
    // Ajustamos su peso al máximo, ya que queremos ver la animación en su plenitud
    this.activeAction.setEffectiveWeight( 1 );
    // Se establece el número de repeticiones
    if (repeat) {
      this.activeAction.setLoop (THREE.Repeat);
    } else {
      this.activeAction.setLoop (THREE.LoopOnce);
    }
    // Una vez configurado el accionador, se lanza la animación
    this.activeAction.play();    
  }
  
  // ******* ******* ******* ******* ******* ******* ******* 
  
  update () {
    // Hay que pedirle al mixer que actualice las animaciones que controla
    //this.camera.lookAt(this.position)
    //this.cameraControl.target = new THREE.Vector3 (this.position.x,this.position.y,this.position.z);
    var dt = this.clock.getDelta();
    if(this.andar)
    {
      
      if(!this.esAndando)
      {      
        this.fadeToAction('Walking',true,1);
        this.esAndando = true;
      }

      this.translateOnAxis(new THREE.Vector3 (0,0,1), dt*3);
    }
    else
    {
      if(this.esAndando)
      {
        this.esAndando = false;
        this.fadeToAction('Idle',true,1);
      }

    }

    if(this.girarDerecha)
    {
      this.rotateY(-1 * dt);
    }
    else if(this.girarIzquierda)
    {
      this.rotateY(1 * dt);
    }

    if(this.saludar)
    {
      console.log("va a saludar")
      this.fadeToAction('Wave',false,1);
      this.saludar = false;
    }


    //this.position.x += 1 * dt;
    if (this.mixer) this.mixer.update (dt);
  }
}

export { Modelo };
