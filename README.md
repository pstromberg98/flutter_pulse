![Logo](https://github.com/pstromberg98/flutter_pulse/blob/master/logo.png)

# Flutter Pulse

CURRENTLY UNDER CONSTRUACTION

Flutter pulse is a library that tackles data synchronization.

## Highlights

- Hooks for easy use
- Uses Future's for any Future based data fetching method
- Uses AsyncSnapshot to represent pulse state

## Project Details

This project is inspired off of libraries like Apollo and React SWR. The focus currently is on data synchronization which this currently achieves but it also is lacking a lot of configuration. Feel free to open issues and submit pull requests

## Concepts

Everything is based around the idea of a "pulse". A pulse is an object that represents a fetchable data source. Multiple listeners can be subscribed to the same pulse and they are all fed the same data as it changes (this is the synchronization part). The pulses are created two ways
- `Pulse('example', () => Future.value('example')` 
- `usePulse('example, Future.value('example')`

The `usePulse` is recommended. The stream of data consists of async snapshots that wrap data. The async snapshots are used as a way to inform the subscribers of the state of the pulse. A good example is a "loading" state would be represented as an AsyncSnapshot with the connection state as waiting. This is useful for displaying loaders while fetching data over the network or local database.

Whenever `usePulse` is used and there is a pulse already existing under that key then it will just subscribe to that existing pulse and emit the latest value. This goes for the `.listen()` method as well
