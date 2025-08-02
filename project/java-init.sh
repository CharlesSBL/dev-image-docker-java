cd ~
mkdir maven-playground
cd maven-playground
mvn archetype:generate \
  -DarchetypeCatalog=remote \
  -DarchetypeGroupId=org.apache.maven.archetypes \
  -DarchetypeArtifactId=maven-archetype-quickstart \
  -DarchetypeVersion=1.5 \
  -DgroupId=com.example \
  -DartifactId=my-app \
  -DjavaCompilerVersion=21 \
  -DinteractiveMode=false
