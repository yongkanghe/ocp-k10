#Inject the sidecar to enable the Generic Volume Snapshot backup, only required for old system without CSI drivers
wget https://github.com/kastenhq/external-tools/releases/download/4.0.2/k10tools_4.0.2_linux_amd64
chmod +x k10tools_4.0.2_linux_amd64
./k10tools_4.0.2_linux_amd64 k10genericbackup inject all -n yong-mysql  
