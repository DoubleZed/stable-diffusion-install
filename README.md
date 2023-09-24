# stable-diffusion-install
Powershell script to install Stable Diffusion
!!!WARNING - Use at your own risk. This is a variation which works for my use cases.

# Manual instructions below
### Create a directory and browse to it via Powershell as admin

### Get Python v3.10.6
```bash
Start-BitsTransfer -Source "https://www.python.org/ftp/python/3.10.6/python-3.10.6-amd64.exe"
```
Install Python from the above exe. Make sure to Enable adding to Path.

### Make sure you have git installed. 
```bash
Start-BitsTransfer -Source "https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.2/Git-2.42.0.2-64-bit.exe"
```
### Then Clone the stable-diffusion-webui repo
```bash
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
```

## Setting up Virtual Environment
SD needs specifically Python v3.10.6. An option to launch SD with the correct python is to enable virtual environment specifically for SD.
SD already uses a venv, but it sets the venv based on which one is the current active python version.
Since v3.10.6 has already been installed from the steps above, all that needs to be done is that venv should created specifically from version 3.10

### Get the current list of python versions installed. Make sure 3.10 is listed.
```bash
py --list
```
### Set up virtual environment in the SD directory where it was cloned with git.
```bash
py -3.10 -m venv D:\..\stable-diffusion-webui\venv
```
### Launch stable-diffusion-webui by running webui-user.bat as a standard user.
```bash
.\webui-user.bat
```
If no models are downloaded and placed inside the \models\Stable-Diffusion folder after the .bat file above is launched, it will automatically download v1-5-pruned-emaonly.safetensors.

Download more models from https://huggingface.co and put them (.ckpt or .safetensors files) in the \stable-diffusion-webui\models\Stable-diffusion directory.

