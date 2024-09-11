# TRACTIAN - Mobile Challenge

## Challenge 🐱‍👤
The challenge is to create a mobile application that consumes the Tractian API and displays the data in a user-friendly tree structure, allowing the results to be filtered by name, status (critical) and sensor type (energy).

### Showcase Video 🎥
[![Showcase Video]](/github/video.mp4)

## What could be done better 🤔
- The data could be stored in a local database to allow better offline usage, using SQFLite and Floor for example.
- The recursive function that builds the tree could be optimized to avoid unnecessary rebuilds, or even use a different approach to build the tree.
- A better approach using isolates for the searching feature, to avoid **freezes when filtering** too much data as in the **third unit**.
- More search filters, other than the ones requested in the challenge.
**(API)** - In a real-world scenario, the API could have a better structure to avoid unnecessary data rework, like reordering the data to build the tree.

## What I learned 📚
- More about Flutter's isolates and how to use them in different scenarios, other than the ones I've used before.
- Recursive functions roundabouts and ways to optimize them.

## My Touches 🎨
- **MVVM*** - For better organization and architecture.
- **Isolates** - For better performance in the search feature.
- **Provider** and **MobX** - For state management.
- **Dio** - For HTTP requests.
- **dio_cache_interceptor** - For caching HTTP requests.
- **Logger** - For better and fancier logs.
- **flutter_svg** - For SVG support.
- **Mocktail** - For testing repositories.

## Thank You! 🙏
- **Tractian** - For the opportunity to participate in this challenge and improve my coding skills with this amazing project!
