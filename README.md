# docker-scripts
* This repo uses powershell scripts and functions to assist in development for Docker containers. Most support is for Docker swarm. This uses some basic assumption on stack name and image names.

# How to Use
* Clone the repo
* Create a env-vars.ps1 file that will hold all environment variables
```
$registryName="some.registry.name"
$tag="master"
$localRegistryName="localhost`:1500"
```
* Open a powershell prompt at the root directory of the repository
* Include all the functions with the include.ps1 file
```
PS > . ./include
```
* Execute any function within the scripts
```
PS > hello-world
Hello from docker-scripts!
```
