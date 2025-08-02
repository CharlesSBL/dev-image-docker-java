docker run -d \
  -p 8080:8080 \
  --name my-java-dev-ubi \
  -e "PASSWORD=your_super_secret_password_here" \
  -v "$(pwd)/my-projects:/home/coder/workspace" \
  java-dev-environment-ubi