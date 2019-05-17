# X250 Mojave

![](https://raw.githubusercontent.com/qwerty12/X250-Hackintosh/screenshots/screenshot.png)

Follow whatever is written here at your own risk. I do not take responsibility for any damage to your device or files caused by following anything on this page.

**This repository makes use of submodules** So, to clone this repo, run `git clone --recursive https://github.com/qwerty12/X250-Hackintosh.git`. Otherwise, you'll be missing a ton of files.

I do not keep a complete EFI folder here. While it does undeniably make things easier, I don't want to be distributing old versions of software, and nor do I want the responsibility of keeping this repository up to date with every kext etc. update.
The TL;DR version of this is something along the lines of use the SSDTs from [here](https://github.com/qwerty12/X250-Hackintosh/tree/master/DSDT_src/patched), grab the config.plist from [here](https://raw.githubusercontent.com/qwerty12/OS-X-Clover-Laptop-Config/master/config_HD5300_5500_6000.plist), [install Clover with the drivers I mention and install the kexts I mention](https://github.com/qwerty12/X250-Hackintosh#clover-configuration).

### Specs of my X250

Component  |             | Notes
------------- | ------------- | ---------- 
CPU  | 2.3 GHz Intel Core i5-5300u (vPro <sub><sup><sub><sup>ugh</sup></sub></sup></sub>) | Make sure to read the CPUFriend short note later on in this writeup
RAM  | Crucial 16 GB 1600 MHz DDR3 | 
IGPU | Intel HD 5500 | QE/CI works, of course
Screen | 1920x1080 LG LP125WF2-SPB2 (00HN899) | Not touchscreen, and brightness control works in Windows
Audio | Realtek ALC3232 | Speakers and headphone output works, as long as the modified ALCPlugFix is installed
Wi-Fi | Dell DW1830 (Broadcom BCM43602) | The original Intel 7265 (with BT) was replaced, as it's not supported by macOS
Bluetooth | Dell DW1830 (Broadcom BCM20703A1) | AirDropping to and from an iPad 4 works fine
Ethernet | Intel I218-LM | No idea if it actually works, but it shows up fine and Mieze's driver is well tested at this point in time
Touchpad | Synaptics PS/2 | The TrackPoint, with VoodooPS2Controller, also works should you feel more inclined to use that instead
WWAN | *Not present* | If your X250 has a WWAN card, then the DW1830 probably isn't the best choice as the DW1830 has three antenna ports - I use one of the WWAN antennas for the Wi-Fi card
SSD | Samsung 860 EVO 512 GB SATA | Works fine. I personally enable TRIM by running `sudo trimforce enable`, but some schools of thought say it's not needed when using APFS
Card reader | Realtek something | sinetek's driver (recommended: [syscl's fork](https://github.com/syscl/Sinetek-rtsx)) might work somewhat; I have not tested it personally

### Problems and other things you should be aware of

* I have only tested this X250 with 10.14.3, 10.14.4 (updated from .3) and 10.14.5. Dark mode is far too enticing for me to test anything else.
    * Something that I was unaware of while updating is that loading kexts from Clover's EFI folder (as opposed to /Library/Extensions etc.) is only possible because Clover hotpatches some component to allow this to happen. When I did the update from .3 to .4, I was getting a kernel panic and I wasn't able to see why because of irrelevant information being dumped to the screen. Long story short, it was because WhateverGreen wasn't being loaded as my Clover version was too old. Newer versions of Clover had already had updated the patch targets for .4 to support kext loading from outside of the standard locations.    
	So, yeah, update your Clover before macOS!
* The batteries drain quite fast. I'm hoping that this is because of me running my laptop at 1680x944 (3360x1888 "Retina"), setting battery thresholds on already-old batteries and not allowing the audio chip to go into powersaving mode when headphones are plugged in
* I don't believe Mojave supports VGA out, and I've never tested the MiniDP. If you do get either working, and changes to the files in this repo were needed in order to do so, please consider creating a PR.
* This writeup uses VirtualSMC instead of the venerable FakeSMC as the former is more resilient if the CMOS checksum gets invalidated. Even the Lenovo UEFI won't reset your settings, but with FakeSMC (or perhaps Clover's SMCHelper-64.efi driver) a hang would occur at the point before Clover could hand over booting to the macOS kernel. FakeSMC does however have the advantage that it can display the fan speed with ACPISensors (if the right bit in SSDT-BATT.dsl is uncommented and the DSDT rebuilt).
* Whilst Lenovo finally got rid of their/IBM's terrible Wi-Fi card whitelist, meaning that one can now switch out the Intel Wi-Fi card (which I do think is better than the DW1830), the UEFI remains locked nevertheless. While it's not really a huge issue, we will forever be at the mercy of the developers behind the following software:
    * Clover to update their built in "KernelPm" patch. MSR 0xE2 is locked by the Lenovo UEFI and a KP happens when macOS attempts to set it: the Clover patch nullifies such attempts
    * WhateverGreen to patch the FB kexts to work with 32MB DVMT-prealloc. The Lenovo UEFI only allocates 32MB, and the EFI variable that controls it is locked. As explained by RehabMan, the Apple framebuffer kexts expect at least 64MB and will KP when it can't get this. The UEFI 256/512 MB GPU memory setting has no relation to this ☹️
* Fn+F10, Fn+F11 and Fn+F12 are all configured to send previous track, play/pause and next track respectively. I mean, you can't have surely been expecting anything different from the person who wrote [this](https://github.com/qwerty12/X250-F10-F12-MediaKeys). You can edit Goldfish64/Hackintosh/Lenovo-ThinkPad-T450/SSDTs/SSDT-FNKEY.dsl for keybindings more appropriate for the labels should you wish.
* I use the `MacBookAir7,2` SMBIOS profile. While `MacBookPro12,1` also works, it has terrible things like "TCP Keep Alive when sleeping" enabled - which, without IGBE's _PRW being hooked (the DSDT here does that), causes instant wakeup from sleep

### Thanks to

* [RehabMan](https://github.com/RehabMan) - his guides on preparing a macOS installer USB, hotpatching the DSDT with Clover and SSDTs etc. are superb. The config.plist used here is based on his config_HD5300_5500_6000.plist and many of his SSDT hotpatches are used here

* [Goldfish64](https://github.com/Goldfish64) - I'm thankful that a developer with such low-level ACPI, UEFI etc. experience worked on Hackintoshing his T450 (same era as the X250, which means they share similar/the same chipsets and ACPI code). His Clover ACPI hotpatches to fix the dual battery reporting, EC reads and writes etc. work great on the X250

* [Sniki](https://github.com/Snikii) - a computer without sound is a terrible thing for most people. That thankfully is not the case here thanks to Sniki's modified AppleHDA kext, and his modified version of goodwin's ALCPlugFix, which ensures sound works over headphones too

* wheatleyisamoron - Wheatley is awesome, and he took the time to confirm that the microphone and camera works. He also told me about the Ethernet driver being a likely cause of the laptop crashing when resuming

Also thanks to the Clover developers, Mieze for her Intel Ethernet driver, the acidanthera collective (most of the third-party kexts I have installed are theirs!), goodwin for ALCPlugFix, Dolnor/TimeWalker75a for CodecCommander and nguyenlc1993 for his ASUS K501L guide showing how to tune AppleGraphicsPowerManagement.kext and X86PlatformPlugin.kext to have the CPU idle at 800MHz and the GPU minimum speed one floor lower.

### Preparation

#### UEFI settings

As it's 2019, I assume you are booting your current OS in UEFI mode. This writeup has never been tested - and never will be - with Clover in legacy mode.

You can update the BIOS too. This writeup was written on a laptop running 1.35. Use the latest UEFI version available. As this guide utilises Clover ACPI hotpatching, this writeup doesn't depend on a pre-patched DSDT specific to a certain UEFI version and configuration.

Assuming the default settings are applied, make the following changes to the UEFI configuration:

Setting   | Value  | Notes |
---|---|---|
Wake on LAN | Off | Whether it actually works in macOS I don't know, but by leaving it off, you might eliminate one cause of early wakeup from sleep
Always on USB | Off | This might be safe to leave on, I have no idea, but all my USB testing has been done with it off
USB 3.0 Mode | Enabled | Must be done. The SSDT, thanks to RehabMan, will turn off the EHCI controller, leaving only the XHCI controller present. Externally, this laptop only has USB 3.0 ports anyway. The only reason this would need to be disabled is if you're running a very old OS that has no USB 3.0 support.
Total Graphics Memory | 512MB | Optional if you're using the standard 1366x768 screen; however, if you're using the 1920x1080 screen, then you will (anecdotally) see better performance with higher resolutions with this bumped up.
Intel Rapid Start Technology | Off | The OS needs to support this, which macOS doesn't, and according to [fraisdos125](https://www.tonymacx86.com/threads/guide-lenovo-x250.206197/), having it on may cause macOS not to boot.
Security Chip | Disabled | I don't know if macOS even supports a TPM, but according to fraisdos125, waking up from sleep may fail with it enabled.
Intel VT-d Feature | Disabled | You can keep this on if you use VT-d in other OSes, as the bootarg `dart=0` and the dropping of the DMAR table will disable VT-d in macOS anyway
Secure Boot | Disabled | Unsurprisingly, Clover isn't signed. 
CSM Support | Yes | You might be able to keep this off if you set a screen resolution in Clover lower than your standard one, but with this off and Clover and macOS set to use the native/same resolution of your screen, you'll see a very distorted logon screen that can only be fixed if you put your laptop to sleep and quickly cancel it. Clover can set the screen resolution to 1920x1080 in CSM mode, so it's not too big a loss.
Ethernet Adapter | Enabled | Even if you don't use the Ethernet card, MacBookPro SMBIOS profiles expect it as en0, not the Wi-Fi adapter

#### Preparing your USB stick

I'll mention this now in the hopes it will be remembered when the time comes: If you do manage to boot into macOS, **DO NOT SIGN INTO ICLOUD**. The config.plist provided here does not have a Mac serial number etc. Should you try to use iMessage etc. without a proper SMBIOS definition, your account may be barred from signing in on a non-iOS device and you'll need to ring up Apple support.

I won't rehash how to create a USB stick with Clover and the Mojave installer on it - RehabMan's comprehensive [guide](https://www.tonymacx86.com/threads/guide-booting-the-os-x-installer-on-laptops-with-clover.148093/) covers everything. dosdude1's patcher can download Mojave from the App Store on a Mac already running Mojave. 
Install the mentioned `mount_efi` script in that thread at the first available opportunity. This writeup assumes you have your EFI partition already mounted when necessary.

There are tools and guides out there for Windows allowing the creation of an Apple recovery USB, from which you can install macOS proper. I did not test this method.

However, contrary to the guide, you should use a newer Clover version (not RehabMan's Clover), the config.plist from this repository, the recommended kexts and UEFI drivers. As RehabMan's guide explains, you'll need to install Clover again after managing to boot into an installed macOS copy on your disk drive using your Clover USB. The config.plist, kexts etc. needed will still be the same.

#### Clover configuration

Install Clover from [here](https://github.com/Dids/clover-builder/releases). I am currently running 4928 but use the latest version where possible. RehabMan's guide linked above goes into more detail on installing Clover. I would recommend selecting the following options in the Clover installer:

* Clover for UEFI booting only
* Install Clover in the ESP
* Themes (optional - if you can spare the space on the EFI partition):
    * Black Green Moody (just in case: it's used by stock RehabMan configs)
    * Clovy (a vast improvement on the default embedded theme)
* UEFI Drivers
    * De-select AudioDxe-64 (unless you really want to hear the Mac chime)
    * De-select DataHubDxe-64 (it's not needed on the X250)
    * Select FSInject-64
    * De-select SMCHelper-64 (we're using VirtualSMC which comes with its own UEFI driver)
    * Select ApfsDriverLoader-64
    * Select AppleImageLoader-64
    * Select AptioMemoryFix-64 - do not select any other Aptio fixes! Despite the name, Lenovo's Phoenix UEFI requires it too
    * Select HFSPlus

You should also install VirtualSmc.efi into drivers64UEFI. This driver comes with the VirtualSMC zip file, which is linked in the kexts list below.
Making sure the EFI partition is mounted (search `mount_efi` on this page), copy X250-Hackintosh/DSDT_src/srcs/RehabMan/OS-X-Clover-Laptop-Config/config_HD5300_5500_6000.plist into /Volumes/EFI/EFI/CLOVER/ and rename it to config.plist

Regarding the APFS and HFS drivers: you'll almost certainly need HFSPlus for booting the macOS installer. The Mojave installer forces the use of APFS on a SSD, so you'll need ApfsDriverLoader to boot the resulting installation. You can get rid of one driver if you're using HFS or APFS everywhere, but keeping both around is the safest option.
I haven't had any bad experiences with APFS personally in the short time I have been using a Hackintosh. APFS, unlike HFS+, supports sparse files. Something to bear in mind if you use NZBGet.

You might want to edit config.plist for the following:

* Removing `NoEarlyProgress` if you want to see the Clover text on bootup before the main Clover screen shows

* Removing `TextOnly`. While I prefer the simplicity of having no theme, Clovy is a great looking theme

* Actually changing the theme

* Changing the language from English

* Removing `-v` from the Boot Arguments. While I recommend keeping this on for the first few days or so so that you may find out what's going wrong during boot, having the Apple logo and macOS loading bar display on boot makes for a nicer startup experience

* Removing `amfi_get_out_of_my_way=1` from the boot arguments. This argument is there to allow mySIMBL to work. While it's not really an issue on a laptop where SIP has to be realistically disabled and unsigned kexts allowed to load, remove it if you feel the security benefits of AMFI are worth having.

* Removing `BooterCfg` - with this set to `log=0`, the text displayed by Clover when a macOS install is selected but before macOS is actually booting will not be displayed (though AptioMemoryFix will still write away). This might be better set in the NVRAM?

Place the following kexts into /Volumes/EFI/EFI/CLOVER/kexts/Other (in brackets are the versions I have installed at the time of writing this writeup, but install the latest versions):

* [Lilu](https://github.com/acidanthera/Lilu/releases) (1.3.5)

* [CPUFriend](https://github.com/acidanthera/CPUFriend/releases) (Optional. I would install this after installing macOS. If installed and using the recommended `MacBookAir7,2` SMBIOS profile, the processor will idle at 800 MHz instead of 1.3 GHz. This was done with the i5-5300U that's in my X250 in mind, so perhaps don't install this kext if you have a different processor?) (1.1.6)

* [IntelMausiEthernet](https://github.com/Mieze/IntelMausiEthernet/releases) - even if you don't plan on using the Ethernet card, it helps with iCloud etc. if the Ethernet card corresponds to the `en0` device on the system (2.4.1d1)

* You can optionally install the modified [LiluFriend](https://github.com/PMheart/LiluFriend) (dependencies added for the Lilu-dependent kexts recommended in this writeup) kext included in this repository. It's not needed when using Clover to load Lilu and Lilu plugin kexts, but should you wish to move everything to /Library/Extensions, you'll find it a huge help

* [RTCMemoryFixup](https://github.com/acidanthera/RTCMemoryFixup/releases) - needed for more reliable sleep and wake. The config.plist here has an appropriate `rtcfx_exclude` set with offsets I found that stop the laptop from saying that the CMOS checksum is wrong on the next reboot after resuming from suspend. The Clover RTC patches do not do anything for this laptop and have been disabled. (1.0.3)

* [USBInjectAll](https://bitbucket.org/RehabMan/os-x-usb-inject-all/downloads/) (0.7.1)

* [VoodooPS2Controller](https://bitbucket.org/RehabMan/os-x-voodoo-ps2-controller/downloads/) (1.9.2)

* [WhateverGreen](https://github.com/acidanthera/WhateverGreen/releases) (1.2.8)

* [VirtualSMC](https://github.com/acidanthera/VirtualSMC/releases) (1.0.3)
    * SMCBatteryManager.kext too for working battery status
    * SMCProcessor.kext for CPU temperature etc.

[Kext Updater](https://bitbucket.org/profdrluigi/kextupdater) is a handy tool for keeping many of the kexts mentioned above up to date. You may find [Hackintool](https://www.insanelymac.com/forum/topic/335018-hackintool-v251/) useful too.

Copy DSDT_src/patched/SSDT-CPUF.aml and DSDT_src/patched/SSDT-IALL.aml into /Volumes/EFI/EFI/CLOVER/ACPI/patched.

If you want to create your own version of the AML files mentioned above from the dsl files, you can run `DSDT_src\produceSSDTs.sh`. You will need the XCode Command Line Tools (for `patch` and `make` at least) and [RehabMan's iasl fork](https://bitbucket.org/RehabMan/acpica/) installed.

SSDT-CPUF.aml is produced by a script that comes with CPUFriend; the MacBookAir7,2 power profile is copied, a small diff applied to lower the base resolution to 800MHz and the aml file with that data is produced by the script.    
SSDT-IALL.aml comes from the SSDTs listed in DSDT_src/srcs/RehabMan/OS-X-Clover-Laptop-Config/hotpatch/SSDT-IALL.dsl. You can add your own SSDTs there and/or edit the SSDTs mentioned with your own changes and then run `DSDT_src\produceSSDTs.sh` to place a new SSDT-IALL.aml into the `patched` folder which you can then copy into Clover.    

`DSDT_src/srcs/RehabMan/OS-X-Voodoo-PS2-Controller/SSDT-Thinkpad_Clickpad.dsl` has a (disabled) hack to set battery charging thresholds on both batteries. It's not the best place to put it, but I needed something that I know would execute at least once on startup without being trigged by a kext I wrote. It's there should you wish to enable it by uncommenting `QTHR`, and changing the thresholds set inside said function.

Injection of the audio layout number is done from the SSDT, see RehabMan's SSDT-HDEF and SSDT-HDEF. For the SSDTs where I made many changes, the repositories containing them originally are included - run `git diff HEAD^` in each folder. This was done so that my changes can easily be separated from those of the original repositories, should you try to use parts of this writeup to run a version of macOS other than one this writeup targets.
When you have time, I recommend looking at the patches applied in the config.plist, produceSSDTs.sh and SSDT-IALL.dsl to understand what is injected. You'll have a far better understanding of what is going on and what to possibly disable in case of problems.

### Post-install stuff

#### Getting working audio

* While AppleALC is probably generally considered the way forward when it comes to audio (layout 28 works with the ALC3232), I have had better experiences with Sniki's patched AppleHDA kext (and CodecCommander & ALCPlugFix). So that is what this writeup will aid you in installing.

* I keep the card reader, webcam and microphone disabled in the UEFI. Wheatley has kindly confirmed that the microphone and webcam work. My X250 does not have a touchscreen; you may need to add whatever port it shows up into OS-X-USB-Inject-All/SSDT-UIAC-ALL.dsl. To get USBInjectAll to attempt its magic with all the USB ports found, you will need to remove its section from the DSDT temporarily.

Place [CodecCommander](https://bitbucket.org/RehabMan/os-x-eapd-codec-commander/downloads/) (2.7.1) into /Library/Extensions.

Copy DSDT_src/Snikii/Lenovo-ThinkPad-X240/kexts/ALC3232.kext into /Library/Extensions

(These can't be loaded from Clover's kext folder: ALC3232 has a symlink to the AppleHDA binary in /System/Library/Extensions [which I don't think works well when stored on a FAT32 filesystem but I could be wrong] and CodecCommander is more reliable if it loads after AppleHDA - if CodecCommander is in the Clover folder, it's more likely that the sound won't be working after booting up.)

After copying everything, run the following in Terminal to ensure sufficient permissions are set on the kext and to rebuild the kext cache:

```
sudo chown -R root:wheel /Library/Extensions/CodecCommander.kext /Library/Extensions/ALC3232.kext
sudo chmod -R 755 /Library/Extensions/CodecCommander.kext /Library/Extensions/ALC3232.kext
sudo touch /System/Library/Extensions && sudo kextcache -u / ; sudo kextcache -i / && sudo kextcache -u /
```

Also install ALCPlugFix for working audio over headphones:

```
cd X250-Hackintosh # wherever it may be
cd DSDT_src/srcs/Snikii/Lenovo-ThinkPad-X240/Audio/alc_fix
sh ./install.sh
```

For some reason, and I'm hoping that it's something I messed up on this install, when headphones are plugged in and you play something with IINA/mpv/VLC and then pause it for a bit, there will be no sound when resuming playback, unless you put the laptop to sleep and wake it up again.

I don't have a fix, just a mere workaround to prevent powersaving when headphones are plugged in:

Install [Mac Audio Keepalive](https://github.com/milgra/macaudiokeepalive) to Applications. Install [Hammerspoon](https://www.hammerspoon.org/). Put this into the init.lua:

```
function startStopOapka(start)
	if start then
		hs.application.open("com.milgra.oapka")
	else
		local oapka = hs.application.get("com.milgra.oapka")
		if oapka then
			oapka:kill()
		end
	end
end

function audioWatch(uid, event, scope, element)
	if (scope == "outp" or scope == "glob") and element == 0 then
		if event == "jack" then
			startStopOapka(dev:jackConnected())
		end
	end
end

dev = hs.audiodevice.findOutputByName("Built-in Output")
if not dev then
	dev = hs.audiodevice.defaultOutputDevice()
end
if dev then
	hs.application.enableSpotlightForNameSearches(false)
	if dev:jackConnected() then
		startStopOapka(true)
	end

	dev:watcherCallback(audioWatch)
	dev:watcherStart()
end
```

With Hammerspoon running, plugging the headphones will start Mac Audio Keepalive and then stop it when unplugging them. As already alluded to, for some reason this problem doesn't occur when the speakers are active.

#### Getting the DW1830 working for Wi-Fi and Bluetooth

Again, the Intel 7265 that comes with the X250 is a good card, but it doesn't work with macOS. There have been various attempts over the years to port the Linux or BSD drivers to macOS but none seem to have really panned out. One alternative is to use a USB dongle, but these do not integrate with macOS's native Wi-Fi solution AirPort and require the use of their unwieldy software to operate the dongle. Not ideal.

The Broadcom-based Dell DW1830 works in Windows 10 (not any earlier versions AFAICT) with a driver you can find on the Dell website, and natively in macOS.

Before I go on, I will point out the following:

* The 7265 wants only two antennas, but the DW1830 expects three. Some say that plugging one into J2 is optional, some say it's needed to help the card balance the load and not overheat. I have no idea what is true.
    * My "solution" was to use one of the additional antenna cables designed for the WWAN card, since my X250 doesn't have a WWAN card. It might be placebo, but [WiFriedX](https://github.com/mariociabarra/wifriedx/) seems to have increased the reliabilty of my connection (if you can live with disabling WiFried whenever you want to use AirDrop).

FakePCIID kexts etc. are not needed.

For Wi-Fi, the one kext I do recommend you install (*to the same place where Lilu.kext resides*) is [AirportBrcmFixup](https://github.com/acidanthera/AirportBrcmFixup/releases) (1.1.9). `brcmfx-country=#a` has already been set in the config.plist boot arguments. Before installing this kext and setting this specific country code, my download speeds was a fraction of what it should have been (and what I was getting from Windows).

##### Bluetooth, Bluetooth, Bluetooth...

Sometimes, turning it off means you can't turn it back on again. I have no idea why.

Anyway, for Bluetooth to work, you need [this](https://github.com/RehabMan/OS-X-BrcmPatchRAM). Read the instructions there carefully. Here's my summary: to load the kext at boot, you need to do one of the following:

* Install BrcmPatchRAM2.kext and BrcmFirmware**Data**.kext to EFI/Clover/kexts/Other.

* The preferred option is to install BrcmPatchRAM2.kext and BrcmFirmware**Repo**.kext to /Library/Extensions

However, I personally do not have the kext load at boot. If you look at the config.plist here, you'll see that in the boot arguments the BRCM kext delays are already set pretty high - values taken from the README of the original project. In my experience, it still wasn't enough to avoid the *3* minute delays (!) I'd sometimes get on boot if the kext wasn't able to upload the firmware to the DW1830's BT chip. And I do not wish to set it any higher. I don't actually use Bluetooth myself, so the delay was unacceptable to me, but I'd still like to have the choice of being able to use Bluetooth.    
So I have the kext load when I log in, instead. This is not a great idea if you rely on external Bluetooth peripherals being available at the login screen, but you'll always have a keyboard and mouse available on an X250...

I put BrcmFirmwareRepo.kext into /Library/Extensions (you must `chmod` and `chown` this properly as was demonstrated in the AppleHDA section) and BrcmPatchRAM2.kext into /kexts. Again, permissions must be set correctly (755, root:wheel) on the /kexts folder and BrcmPatchRAM2.kext. 

Run `EDITOR=nano sudo visudo` and add the following rule at the end:

```
%admin ALL= NOPASSWD: /sbin/kextload /kexts/BrcmPatchRAM2.kext
```

Ideally, a LaunchAgent would then run the sudo command to load a kext, but I'm lazy and have the following in my [Hammerspoon](https://www.hammerspoon.org/) init.lua:

```
os.execute("/usr/bin/sudo /sbin/kextload /kexts/BrcmPatchRAM2.kext >/dev/null 2>&1")
```

After you've set up the kexts, open the Bluetooth Preference Pane and tick the option to show the Bluetooth icon in the status bar if you want. If you have too many status bar icons, try the freeware Dozer program.

#### Getting iCloud and iMessage to work

I can't explain this better than P1LGRIM's [
An iDiot's Guide To iMessage](https://www.tonymacx86.com/threads/an-idiots-guide-to-imessage.196827/) can. I've had a successful experience with it twice. Follow the given instructions to the letter and you'll be OK.

However, when you use Clover Configurator, don't load your current config into it, choose `MacBookAir7,2`, and save the generated config.plist elsewhere. You can then manually put the SMBIOS section from the generated config.plist into your current config.plist on the EFI partition using a text editor.

#### Getting the iGPU to idle one step lower

Install the included AppleGraphicsPowerManagement_Broadwell.kext into /Library/Extensions. Make sure to `chmod`, `chown` it properly and rebuild the kext cache.

Running 
`ioreg -rlw0 -p IOService -c AGPMController -k Machine | grep GT` after rebooting will tell you if the kext has been installed properly - GT2Floor and GT3Floor should be 6.

This kext comes from a Mojave .4 install, with the the GT{2,3}Floor properties modified and a higher version number etc. set to ensure this kext gets used instead of the original one from /S/L/E. Read nguyenlc1993's Asus guide on GitHub if you wish to make your own kext to do this.

#### Undervolting the CPU and GPU

Entirely, entirely, optional but the option is there. 

[VoltageShift](https://github.com/sicreative/VoltageShift) works fine on my X250.

I won't mention the settings I use, because all processors are different - you might be able to undervolt more than I can or you may have to undervolt less if you're running into system freezes or spontaneous resets. (I realised I was undervolting the CPU too much when attempting to update Xcode from the App Store and watching something with IINA would cause a reset every time. Worked fine otherwise, just apparently not under heavy load.)


#### Using "Retina" resolutions with the 1080p screen

If you have a 1080p panel in your X250 (attempting this with a 1366x768 screen is a waste of time), you might find that the screen is too physically small to really be able to see things clearly at 1920x1080 all the time. What I do is this: run in 1680x944 in Retina mode - 3360x1888 downscaled - but switch to 1920x1080 when watching something with IINA.

To enable Retina mode, I recommend using [one-key-hidpi](https://github.com/xzhih/one-key-hidpi/). It's very easy to use, and will enable the Retina-style Display Preference Panel (even if the resolutions don't exactly match up with the description).

If you wish to do it somewhat more manually, use usr-sse2's [fork of RDM](https://github.com/usr-sse2/RDM/). Use its edit function and add the following resolutions:

Horizontal   | Vertical  | HiDPI |
---|---|---|
1920 | 1080 | 
3360 | 1888 | ☑️
1680 | 944 | ☑️

Reboot. If you don't see the new resolutions in the Display Preference Panel when holding the Option key, set it with RDM. You may have to do this on every startup. Again, one-key-hidpi works great.

See [this](https://www.tonymacx86.com/threads/adding-using-hidpi-custom-resolutions.133254/) for more information.

#### A better colour profile for the 1080p LP125WF2-SPB2

https://github.com/soleblaze/icc/raw/master/lp125wf2-spb2.icc

[Source](https://github.com/gartempe/MacOS-Thinkpad-Yoga-12)

#### Better font rendering on 1366x768

From the Terminal, run:

```
defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO
defaults write NSGlobalDomain AppleFontSmoothing -int 2
```

Log out and log in again.

#### Making the Wi-Fi toggle key work

This isn't the best solution out there - this will not work at the login screen or in secure password entry prompts - but I simply do not have the time nor knowledge to implement something compatible with the existing Lenovo hotkey system to detect Fn keypresses.

With the SSDT here, pressing the Wi-Fi key will send F17 to the system.

You can use Hammerspoon to detect and perform specified actions on said keypresses by putting the following into the init.lua:

```
hs.hotkey.bind({"Ctrl"}, "F17", function()
	hs.wifi.setPower(not hs.wifi.interfaceDetails()["power"])
end)
	
hs.hotkey.bind({}, "F17", function()
	os.execute("/usr/local/bin/blueutil -p toggle")
end)
```

`blueutil` comes from [Homebrew](https://brew.sh) so install it if you want Bluetooth toggling to work.
With this config, you can press Fn+F8 to toggle Bluetooth and if you press Ctrl+Fn+F8, Wi-Fi will be toggled.
This assumes you're using a Wi-Fi and Bluetooth solution natively supported by macOS.

#### Disable hibernation

Hibernation *might* work if you install acidanthera's HibernationFixup, because RTCMemoryFixup isn't blocking the offsets used by hibernation. I've certainly not tried hibernation here.

The safe thing to do is to disable hibernation by running the following:

```
sudo pmset -a hibernatemode 0
sudo rm /var/vm/sleepimage
sudo mkdir /var/vm/sleepimage
```

and possibly

```
sudo pmset -a standby 0
sudo pmset -a autopoweroff 0
```

[Source](https://www.tonymacx86.com/threads/guide-native-power-management-for-laptops.175801/)

#### Setting the default OS to boot into on startup

You can of course edit config.plist to your heart's content, but the config.plist and Clover honours the choice made from the Startup Disk Preference Pane. There is the `LastBootedVolume` option available too.

#### Better mouse and keyboard settings

The keyboard layout in use should preferably be the PC variant of whatever keyboard layout you have.

From the Trackpad Preference Pane, set secondary click to "click in bottom right corner" if you want to have the trackpad's buttons actually perform a right-click in addition to having a left-click option.
I don't think the gestures there work; you're meant to go to the keyboard settings, edit a shortcut for something and perform your desired swipe action.

The laptop's PrtSc key is bound to F13 - you can edit the various screenshot shortcuts in the Keyboard Preference Pane to use the PrtSc key if you wish.

#### Caps lock indicator

The freeware [Captin](http://captin.strikingly.com) program can be used to show the caps lock status when the button is pressed. A hex editor can be used to zero out the OFF and ON labels, making it more closer to how the Lenovo OSD looks.

#### ThinkPadMuteLEDSetter

If anybody wants to make a better version of [ThinkPadMuteLEDSetter](https://github.com/qwerty12/ThinkPadMuteLEDSetter), I'll be happy to use it. The source-only ThinkPadMuteLEDSetter can toggle the laptop's mute LED on demand, so it accurately reflects the current mute state even if the laptop was muted by means other than pressing the physical mute button.
