# Utilizar la imagen base de Tomcat
FROM tomcat:8.5-jdk22

# Establecer el directorio de trabajo en Tomcat
WORKDIR /usr/local/tomcat/webapps/

# Copiar el proyecto "Parcial2" completo en el contenedor
COPY ./Parcial2 /usr/local/tomcat/webapps/Parcial2/

# Copiar el conector de MySQL y JSTL a la carpeta de librerías de Tomcat
COPY ./Parcial2/WEB-INF/lib/mysql-connector-j-8.2.0.jar /usr/local/tomcat/lib/
COPY ./Parcial2/WEB-INF/lib/javax.servlet.jsp.jstl-1.2.5.jar /usr/local/tomcat/lib/

# Exponer el puerto 8080 para Tomcat
EXPOSE 8080

# Comando para iniciar Tomcat
CMD ["catalina.sh", "run"]
