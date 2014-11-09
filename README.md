ovh-power8-mariadb-benchmarking
===============================

# Background

This project documents how a comparitive benchmarking study was done to assess MariDB performance with Linux operating systems on Power8 architectures in a public cloud setting. Specifically the following combinations were considered:

| Attribute | Value |
| :--------- |:----- |
| Cloud Service Provider | [OVH Runabove](https://www.runabove.com/index.xml) |
| System Architecture | [IBM Power8](http://www-03.ibm.com/systems/power/software/linux/) with PowerKVM 2.1.0 |
| VM Flavor(s) | ra.p8.s ( 8VCPU, 4GB RAM, 10GB Disk ) |
|              | ra.p8.2xl ( 176VCPU, 480GB RAM, 480GB Disk ) |
| Operating System(s) | [Fedora](http://fedoraproject.org/) 19 (BigEndian) |
|                     | [SUSE Linux Enterprise Server](https://www.suse.com/products/server/) 12 (LittleEndian) |
|                     | [Ubuntu](http://www.ubuntu.com/server) 14.04 (LittleEndian) |
| Database | [MariaDB](https://mariadb.org/) |
| Benchmark Tool(s) | [SysBench](https://launchpad.net/sysbench) |

The goal is to compare performance across the following variables/settings:

* Simultaneous Multi-Threading : On(8), 4, 2, 1 Off
* SysBench parallel number of threads : 1 2 4 8 16 32 64 128
* Notes:
	* where possible, utilize in-distro components, updated to the latest provided
	* perform no patching nor tuning of database or benchmarking components

# Process

The process for setup, configuration, data collection and analysis was as follows:

* Setup
	* obtain account with CSP with access to desired VM flavors
	* upload any operating systems images not already available
	* launch each instance combination (operating system + VM flavor)
	* login to each instance, then
		* install mariadb packages from distribution
		* install sysbench packages from distribution (or find equivalent version and compile from source, as needed), yielding the resulting combinations:

| Operating System | MariaDB version | SysBench version(s)|
| ---------------- | --------------- | ------------------ |
| Fedora 19 | 5.5.38 | 0.4.12, 0.5-128 |
| SUSE Linux Enterprise Server 12 | 10.0.1 | 0.4.12.5, 0.5-128 |
| Ubuntu 14.04 | 5.5.39 | 0.4.12, 0.5-128 |

* Configuration
	* secure MariaDB installation with known username and password
		* place these values in "[.mariadbrc](./scripts/.mariadbrc)" file to be sourced by the scripts
	* ensure that MariaDB can run in safe mode (with no networking access)

* Data Collection
	* use [scripts](./scripts) to standardize testings, and produce output to known file names
		* perform a simple CPU benchmark, see [sysbench-cpu.sh](./scripts/sysbench-cpu.sh)
		* prepare a target database, see [sysbench-prepare.sh](./scripts/sysbench-prepare.sh)
		* perform an initial database benchmark, see [sysbench-ovh.sh](./scripts/sysbench-ovh.sh)
		* perform a matrix of mixed used database benchmark, see [sysbench05-oltp.sh](./scripts/sysbench05-oltp.sh), includes another database preparation

* Analysis
	* collect the resulting [data](./data) files from the VMs to another host for processing
		* Note the structure of the data files, including directory names, since the following extraction and analysis scripts derive values from those descriptive names
	* in each of the OperatingSystem-VMFlavor directories use the respective shell [scripts](./scripts) to read the collected data and summarize desired results into simple CSV files 
		* [extract-cpu.sh](./scripts/extract-cpu.sh)
		* [extract-ovh.sh](./scripts/extract-ovh.sh)
		* [extract05-oltp.sh](./scripts/extract05-oltp.sh)
		* samples of these CSV output files can be found in the [data](./data) directory of this project
	* use the respective [R](http://www.r-project.org/) [scripts](./scripts) to read the CSV [data](./data) files, and generate graphs of the [results](./results)
		* [analyze-cpu.R](./scripts/analyze-cpu.R)
			* ![CPU Benchmark](./results/s-cpu.png)
		* [analyze-ovh.R](./scripts/analyze-ovh.R)
			* ![MariaDB Benchmark](./results/ovh.png)
		* [analyze05-oltp.R](./scripts/analyze05-oltp.R)
			* ![OLTP Benchmark](./results/oltp.png)

# Conclusions
