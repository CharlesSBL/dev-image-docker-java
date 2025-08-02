# Create a folder on your C: drive to store your projects
# For example: mkdir C:\my-dev-projects

# Run this command in PowerShell
docker run -d `
  -p 8080:8080 `
  --name my-java-dev-ubi `
  -e "PASSWORD=your_super_secret_password_here" `
  -v "C:\my-dev-projects:/home/coder/workspace" `
  java-dev-environment-ubi