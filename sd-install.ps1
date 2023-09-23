$AutoDownloadAImodels = 'Yes'
$Packages = 'git', 'python', 'pip'
$AIdatadir = 'D:\Temp\stable-diffusion\AI'
$url = 'https://github.com/AUTOMATIC1111/stable-diffusion-webui.git'
$AImodels = 'https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt'

function RunAsAdmin {

    # Get the ID and security principal of the current user account
    $myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
    $myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
  
    # Get the security principal for the Administrator role
    $adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
  
    # Check to see if we are currently running "as Administrator"
    if ($myWindowsPrincipal.IsInRole($adminRole))
        {
        # We are running "as Administrator" - so change the title and background color to indicate this
        $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
        #$Host.UI.RawUI.BackgroundColor = "DarkBlue"
        $Host.UI.RawUI.BackgroundColor = "Black"
        clear-host
        }
    else
        {
        # We are not running "as Administrator" - so relaunch as administrator
    
        # Create a new process object that starts PowerShell
        $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    
        # Specify the current script path and name as a parameter
        $newProcess.Arguments = $myInvocation.MyCommand.Definition;
    
        # Indicate that the process should be elevated
        $newProcess.Verb = "runas";
    
        # Start the new process
        [System.Diagnostics.Process]::Start($newProcess);
    
        # Exit from the current, unelevated, process
        exit
        }
}

function InstallChoco {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function CreateFolders {
    New-Item -ItemType Directory -Path $AIdatadir -ErrorAction SilentlyContinue
    Set-Location $AIdatadir
}

function InstallDeps {
    ForEach ($PackageName in $Packages) {
        choco install $PackageName -y
    }
    CreateFolders
    PrepGit
    DownloadModels
    InstallWebUI
}

function Invoke-GitClone($url) {
        Write-Output 'Setting the folder'
        $name = $url.Split('/')[-1].Replace('.git', '')
        & git clone $url $name | Out-Null
        $loc = $name + '\models/Stable-diffusion'
        Write-Output 'Setting current directory to $loc'
        Set-Location $loc
    }

function PrepGit {
    Write-Output 'Preparing git folders'
    Invoke-GitClone($url)
}

function DownloadModels {
    if ($AutoDownloadAImodels -eq 'yes'){
        Write-Output 'Attempting to download Stable Diffusion AI models '
            ForEach ($model in $AImodels) {
                Write-Output $model
                Start-BitsTransfer -Source $model
            }
    }
}

function InstallWebUI {
    Set-Location $AIdatadir\stable-diffusion-webui
    Start-Process -filepath .\webui-user.bat -argumentList @("/K") -NoNewWindow
    Pause (5)
    Start-Process "http://127.0.0.1:7860"

}

RunAsAdmin

If(Test-Path -Path "$env:ProgramData\Chocolatey") {
    InstallDeps}
Else {
    InstallChoco
    InstallDeps
}
