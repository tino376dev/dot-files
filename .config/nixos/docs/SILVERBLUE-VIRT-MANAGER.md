# virt-manager on Silverblue

## Install

For a persistent host installation, layer virt-manager and reboot:

```bash
rpm-ostree install virt-manager
```

A temporary user overlay may disappear on reboot.

## Enable libvirt sockets

Start the modular libvirt sockets for QEMU, networking, and storage:

```bash
sudo systemctl enable --now virtqemud.socket virtnetworkd.socket virtstoraged.socket
```

The sockets should be active and listening. Their corresponding daemon services
may show as inactive until a client connects; systemd starts them on demand.

## Fix a missing PolicyKit action

If `virsh` reports that `org.libvirt.unix.manage` is not registered, check that
the libvirt policy file is installed:

```bash
grep -F 'org.libvirt.unix.manage' /usr/share/polkit-1/actions/org.libvirt.unix.policy
```

If the action is present, restart PolicyKit so it reloads the installed policy:

```bash
sudo systemctl restart polkit
```

## Verify and inspect VMs

List system VMs and their states:

```bash
virsh -c qemu:///system list --all
```

Print a VM's XML configuration:

```bash
virsh -c qemu:///system dumpxml "VM name"
```

In this setup, the system connection listed `nixos-unstable` as shut off.
