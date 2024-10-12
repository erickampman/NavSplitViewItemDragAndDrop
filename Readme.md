#  NavSplitViewItemDragAndDrop

- Although this is a multiplatform app, running this on an ipad I see that D&D does not work. Right now not too intersested in why. AFAIK the mac version works ok, including:
	- Dragging from sidebar to detail
	- Dragging from detail to sidebar
	- Reordering in both detail and sidebar
	- Appending from sidebar to detail by dragging to the right of existing items.
	- Appending from detail to sidebar by dragging to the bottom of existing items.

- Strings are used as a proxy for the items being dragged. From the SidebarContainerDropDelegate comments:

		`although we are "moving" Items from one place to another, the DropInfo
		data is just a string. I've fought with loadObject below, trying to use a
		Transferable object instead of a String, but I've given up.`

- Long tap is implemented in the detail view to show how it might be used. 

- Arrows are displayed in 'dragged to' items to indicate where the dropped item will be placed (above or to the right of the item). I don't move the item until performDrop to avoid issues where the drag ends somewhere where there is no logic for it and the item has already been moved. 

	- A possible TODO would be to cover the entirety of the detail view with a view that does have a corresponding drop delegate. That way the item can be moved in dropEntered and that would give a nicer presentation. 
	








