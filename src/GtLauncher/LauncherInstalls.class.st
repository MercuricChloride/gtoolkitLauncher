Class {
	#name : #LauncherInstalls,
	#superclass : #Object,
	#category : #'GtLauncher-Ui'
}

{ #category : #accessing }
LauncherInstalls >> asElement [
	| list container |
	container := self pane.
	list := self list.
	list items: self installs.
	
	container addChild: list.

	^ container.
]

{ #category : #'as yet unclassified' }
LauncherInstalls >> header [
	| aHeader name date |
	aHeader := BlElement new.
	aHeader
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
			
	aHeader layout: (BlLinearLayout horizontal alignCenterLeft; cellSpacing: 50).
	aHeader padding: (BlInsets top: 5 bottom: 5).
	name := BrLabel new
			aptitude: BrGlamorousLabelAptitude;
			text: 'Name'.
	date := BrLabel new
			aptitude: BrGlamorousLabelAptitude;
			text: 'Install Date'.

	aHeader
		addChild: name;
		addChild: date.

	^ aHeader
]

{ #category : #accessing }
LauncherInstalls >> installActionsFor: anInstall [
	| actions |
	actions := {'Run' -> [ :e | anInstall run ].
			'Delete' -> [ :e | anInstall inspect ]} asOrderedCollection.
	^ BrGlamorousSimpleContextMenuContent new 
		items: actions
]

{ #category : #accessing }
LauncherInstalls >> installs [
	^ (GtlConfiguration imagesPath entries select: [ :each | each isDirectory ])
		collect: [ :each | GtInstall newFrom: each reference ]
]

{ #category : #'as yet unclassified' }
LauncherInstalls >> interactionButtons [
	| aHeader name date |
	aHeader := BlElement new.
	aHeader
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
			
	aHeader layout: (BlLinearLayout horizontal alignCenterLeft; cellSpacing: 50).
	aHeader padding: (BlInsets top: 5 bottom: 5).
	name := BrLabel new
			aptitude: BrGlamorousLabelAptitude;
			text: 'Name'.
	date := BrLabel new
			aptitude: BrGlamorousLabelAptitude;
			text: 'Install Date'.

	aHeader
		addChild: name;
		addChild: date.

	^ aHeader
]

{ #category : #accessing }
LauncherInstalls >> list [
	| aList |
	aList := BrColumnedList new aptitude: BrColumnedMultiListAptitude.

	aList
		rowStencil: (BrColumnedListItemElementWithContextMenuDecorator new
			stencilBuilder: BrGlamorousColumnedListSelectableRowElementStencilBuilder new;
			contextMenuStencil: [ :anElement :anInstall | 
				self installActionsFor: anInstall ] );
		padding: (BlInsets top: 5);
		matchParent.

	aList column
		title: 'Name';
		cellStencil: [ BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				padding: (BlInsets all: 12) ];
		dataBinder: [ :eachElement :eachInstall :eachIndex | eachElement text: eachInstall name ].

	aList column
		title: 'Installed On';
		cellStencil: [ BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				padding: (BlInsets all: 12) ];
		dataBinder: [ :eachElement :eachInstall :eachIndex | eachElement text: eachInstall installedOn ].

	aList
		when: BrSelectionDoubleClicked
		do: [ :anEvent | 
			anEvent selection
				ifNotEmpty: [ :theIndices | 
					| aWidgetElement selectedObject |
					aWidgetElement := anEvent currentTarget.
					selectedObject := aWidgetElement viewModel itemAt: theIndices first.
					selectedObject inspect ] ].

	^ aList
]

{ #category : #'as yet unclassified' }
LauncherInstalls >> pane [
	^ BrVerticalPane new
		matchParent;
		addChild: self header
]
