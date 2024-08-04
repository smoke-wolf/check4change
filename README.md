Project Title: Webpage Monitor and Checksum Recorder
====================================================

![GitHub stars](https://img.shields.io/github/stars/smoke-wolf/check4change?style=for-the-badge) ![GitHub license](https://img.shields.io/github/license/smoke-wolf/check4change?style=for-the-badge)

Overview
--------

Webpage Monitor and Checksum Recorder is a handy Bash script that allows you to monitor webpages, calculate and record their checksums, and check for changes over time. This simple yet powerful tool can be useful for website administrators, developers, or anyone interested in tracking the integrity of web content.

Whether you want to ensure your website's content remains unchanged or verify the authenticity of online resources, this script has you covered. Easily keep an eye on your favorite webpages, record checksums, and get notified when changes occur.

Features
--------

-   Checksum Calculation: Calculate the SHA1 checksum of a webpage to verify its integrity.
-   Record Checksums: Record checksums and timestamps for monitored webpages in a data file.
-   Change Detection: Detect and report changes in webpage content.
-   User-Friendly: Simple command-line interface for easy interaction.
-   Cross-Platform: Works on both Linux and macOS.

Getting Started
---------------

### Prerequisites

-   Bash (Linux or macOS)
-   `curl` for fetching webpage content
-   `shasum` for checksum calculation (pre-installed on macOS)
-   `awk` for text processing

### Installation

1.  Clone the repository:

    

    `git clone https://github.com/smoke-wolf/check4change.git
    cd your-repo-name`

2.  Make the script executable:

    

    `chmod +x webpage_monitor.sh`

### Usage

-   Monitor a Webpage (using last recorded checksum):

    

    `./webpage_monitor.sh -m <URL>`

-   Compare a Checksum and a URL:

    

    `./webpage_monitor.sh -c <checksum> <URL>`

-   Load and Display Records:

    

    `./webpage_monitor.sh -l`

-   Display a List of Websites with Recorded Checksums:

    

    `./webpage_monitor.sh -lm`

Examples
--------

### Ruby Mode
`ruby ccm.rb` 
This will load the analyzer.

### live moniter mode (lMM)
Run the script with the URLs you want to monitor:



`./m4c.sh <URL1> [URL2] [URL3] ...`

#### Example


`./m4c.sh "https://www.theguardian.com/international" "example.com"`

### Monitor a Webpage

Monitor a webpage using the last recorded checksum:



`./webpage_monitor.sh -m https://example.com`

### Compare a Checksum and a URL

Compare a checksum with a URL to check for changes:



`./webpage_monitor.sh -c <checksum> https://example.com`

### Display Records

Load and display recorded webpage records:



`./webpage_monitor.sh -l`

### Display Website List

Display a list of websites with recorded checksums:



`./webpage_monitor.sh -lm`

Contributing
------------

If you find a bug, have a feature request, or would like to contribute to this project, please feel free to create an issue or submit a pull request.

License
-------

This project is licensed under the MIT License.

Acknowledgments
---------------

-   This script was created by Smoke-wolf.

We hope you find this tool useful for monitoring and recording webpages
