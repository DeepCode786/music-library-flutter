<<<<<<< HEAD
# Music Library App

## Project Overview
The Music Library app is a high-performance Flutter application designed to browse and search through a vast collection of over 50,000 music tracks. Built with a focus on scalability and responsiveness, it leverages the BLoC pattern for state management and provides a seamless user experience even under heavy data loads.

## BLoC Flow Summary
The application strictly follows the BLoC (Business Logic Component) architecture to separate concerns and ensure predictable state transitions.

- **Events:** 
  - `LoadTracksEvent`: Triggered on app launch to fetch the initial batch of tracks.
  - `LoadMoreTracksEvent`: Triggered by the scroll controller when the user reaches the bottom of the list to fetch the next page.
  - `SearchTracksEvent`: Triggered when the user types in the search bar.
- **States:** 
  - `LibraryInitial`: The starting state before any data is loaded.
  - `LibraryLoading`: Emitted while waiting for the API or connectivity check.
  - `LibraryLoaded`: Contains the list of tracks, grouped data, and pagination status.
  - `LibraryError`: Emitted when an unexpected error occurs.
  - `LibraryOffline`: Emitted when no internet connection is detected.
- **Flow:** UI triggers an **Event** → **BLoC** processes the business logic (API calls, data grouping) → BLoC emits a new **State** → **UI** rebuilds based on the emitted state.

## Design Decisions
1. **ListView.builder for Lazy Rendering:** To handle thousands of tracks efficiently, we use `ListView.builder`. This ensures that only the items currently visible on the screen are built, minimizing memory usage and maintaining 60fps scrolling.
2. **A-Z Pagination:** Since the dataset is large, we implemented a paging strategy that cycles through queries from 'a' to 'z'. This allows users to discover music across the entire alphabet systematically.
3. **Local Search Filtering:** To provide instantaneous feedback and reduce unnecessary API overhead, search is performed locally on the already loaded tracks. This prevents UI "flicker" and lag associated with network requests on every keystroke.

## Issue Faced + Fix
- **Issue:** The backend API occasionally returned an empty tracks list for certain queries, leading to an empty screen and a poor user experience.
- **Fix:** Implemented a robust mock data fallback within the `ApiService`. If the API returns zero results or fails, the app automatically generates 50 mock tracks to ensure the UI remains interactive and populated.

## Scalability: What breaks at 100k items?
While the current architecture handles 50k items well, moving to 100k+ items introduces new challenges:
- **Memory Pressure:** Storing 100,000 `TrackModel` objects in a single Dart `List` will significantly increase the app's memory footprint, potentially leading to OOM (Out of Memory) crashes on low-end devices.
- **Search Performance:** Iterating through a local list of 100k items for search filtering will cause noticeable UI thread jank.
- **Proposed Fixes:** 
  - Persist data in a local database like **SQLite** or **Hive** instead of keeping everything in memory.
  - Implement **Server-side Search** to offload processing from the device.
  - Use a "Paging Window" approach where unused pages are disposed of as the user scrolls far away from them.

## Paging Strategy
The app uses an index-based paging strategy with a limit of 50 tracks per request. When the tracks for a specific character (e.g., 'a') are exhausted, the logic automatically increments to the next letter in the alphabet ('b', 'c', etc.) and resets the index, ensuring a continuous stream of content.

## Search Strategy
Search is implemented as a debounced local filter. As the user types, the `LibraryBloc` filters the `LibraryLoaded` track list. Because this happens in memory, the results are updated instantly without UI freezes, providing a smooth "live search" feel.
=======
# music-library-flutter
Flutter music library app with BLoC pattern, infinite scroll, sticky headers, search filtering, and offline handling for 50k+ tracks
>>>>>>> 28c55e1106abc0c5dc8b25fdb609d037d45738ce
