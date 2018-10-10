# iTunes Search app

## Main functionality

Search iTunes titles using text query

## State

WIP, search is not working correctly for now

## Details

* Supports reloading all content
* Supports landscape
* Supports all iPhone/iPad screen sizes and interface orientations


## Implementation details

* Swift 4 and XCode 10
* No thirdparty frameworks or libraries were used
* Some functional swift approaches were applied (`Result.swift` for example)


## Architectural approaches

* MVVM-Coordinator as the main architectural approach
* Simple dependency injection in `ViewModels` and some `Coordinators` (as no frameworks are used)
* Protocol driven development in main services for easier testing

