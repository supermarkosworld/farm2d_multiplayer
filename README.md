# farm2d_multiplayer

A 2D farming game built in Godot Engine 4.3, integrating concepts from tutorials by Rapid Vectors and BatteryAcidDev to implement multiplayer functionality.

## Features Implemented

This project incorporates elements from two main learning sources:

**Core Farming Game Mechanics (Based on Rapid Vectors' Tutorial Series):**

*   **Player Character:** `CharacterBody2D` based player with movement.
*   **State Machine:** `NodeStateMachine` implementation for managing player states (e.g., `Idle`, `Walk`, `Chopping`, `Tilling`, `Watering`).
*   **Basic Tool System:** Selection of tools (Axe, Hoe, Watering Can, Seeds) via a UI panel (`ToolsPanel`).
*   **Interaction Components:** Use of `HitComponent` and `HurtComponent` for action detection (e.g., tool hitting an object).
*   **Animation:** Basic animation handling tied to player states and direction.

**Multiplayer Integration (Based on BatteryAcidDev's Tutorial):**

*   **Networking Backend:** Uses Godot's high-level Multiplayer API with `ENetMultiplayerPeer`.
*   **Host/Client Logic:** `MultiplayerManager` handles starting a server (`become_host`) and connecting as a client (`join_as_player`).
*   **Player Spawning:** Players are instantiated and added to the scene when peers connect (`_add_player_to_game`). Currently uses a fixed spawn point.
*   **Synchronization:**
    *   `MultiplayerSynchronizer` (`PlayerSynchronizer`) used for replicating essential player data (like `player_id`, `position`, `current_tool`).
    *   `InputSynchronizer` pattern for handling player input across the network.
*   **Remote Procedure Calls (RPCs):**
    *   Tool selection uses an RPC (`update_tool_server`) sent from the client's `GameManager` to the server's `Player` instance to update the `current_tool` authoritatively.
    *   (Implied: Tool actions likely use RPCs from client input to server logic).
*   **Authority Management:** Uses `is_multiplayer_authority()` checks (e.g., for camera enabling) and sets authority based on `player_id`.

**Integration Notes:**

*   The UI tool selection triggers an RPC to the server, which updates the synchronized `current_tool` variable on the authoritative `Player` instance.
*   The `HitComponent` now reads the player's state (`StateMachine`) and the synchronized `current_tool` to determine when its collision shape should be active for detecting hits during action states.
*   Player movement is calculated and applied server-side based on synchronized input.
*   Player-player collision is currently disabled via physics layers/masks to prevent pushing.

## Acknowledgements

This project builds heavily upon the excellent tutorials provided by:

*   **Rapid Vectors:** ["How to Build a Complete 2D Farming Game an 8-Hour Tutorial Series - Godot 4.3 - All 25 Episodes"](https://www.youtube.com/playlist?list=PLgQ3fptSXLHLrXpPe26zkVAr411H6wqaL) 
*   **BatteryAcidDev:** ["Add Multiplayer to your Godot Game!"](https://www.youtube.com/watch?v=nRvrlnAREI4) 


