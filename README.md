# Vault Playground on Kubernetes

This repository provides a playground with bootstrap code to experiment and explore HashiCorp Vault.

The repository currently focuses on integration with the following authentication methods and external systems:
- AppRole
- LDAP (OpenLDAP)
- Kubernetes API 
- Monitoring (Prometheus/Grafana)

## Prerequisites

The playground runs with either Minikube or Kind. The prerequisites slightly differ.
See [./SETUP.md](./SETUP.md) for more details.


Tested with:
- *Fedora 36*
- *OpenSuse Tumbleweed*

Note:
- phpldapadmin Docker container requires cgroup v2

## Usage Instructions and FAQ

See [./USAGE.md](./USAGE.md)

## Code of Conduct

This repository has a [code of conduct](CODE_OF_CONDUCT.md), we will
remove things that do not respect it.

## About this repository

As a company, we shape a world of innovative, sustainable and resilient IT solutions
built on trustworthy open source technology to unlock the full potential of our customers.

This repository contains part of the action behind this commitment. Feel free to
[contact](https://adfinis.com/en/contact/?pk_campaign=github&pk_kwd=vault)
us if you have any questions.

## License

This application is free software: you can redistribute it and/or modify it under the terms
of the [GNU General Public License](./LICENSE) as published by the Free Software Foundation,
version 3 of the License.