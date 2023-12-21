FROM mobiledevops/flutter-sdk-image
USER root


RUN apt-get update & apt-get upgrade
RUN git config --global --add safe.directory /home/mobiledevops/.flutter-sdk

RUN flutter upgrade

CMD make

#CMD flutter pub upgrade
#CMD flutter test test/test_unidad1.dart