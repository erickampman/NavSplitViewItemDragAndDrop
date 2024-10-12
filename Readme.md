#  NavSplitViewItemDragAndDrop

- Although this is a multiplatform app, running this on an ipad I see that D&D does not work. Right now not too intersested in why. AFAIK the mac version works ok, including:
	- Dragging from sidebar to detail
	- Dragging from detail to sidebar
	- Reordering in both detail and sidebar
	- Appending from sidebar to detail by dragging to the right of existing items.
	- Appending from detail to sidebar by dragging to the bottom of existing items.

- Items have their own UTType, and are what is being dragged and dropped. 
- Previous projects used the DropInfo argument passed into DropDelegate methods. I've found this to be difficult to use for custom Transferable object, so is not used here. 

- Long tap is implemented in the detail view to show how it might be used. 

	








