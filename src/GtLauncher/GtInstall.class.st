Class {
	#name : #GtInstall,
	#superclass : #Object,
	#instVars : [
		'path',
		'contents'
	],
	#category : #'GtLauncher-Models'
}

{ #category : #'as yet unclassified' }
GtInstall class >> newFrom: aPath [
	^ self new
		path: aPath
]

{ #category : #'as yet unclassified' }
GtInstall >> contents [
	| file |
	file := path / 'startup.st'.
	^ file exists ifTrue: [ file contents ] ifFalse: [ '' ]
]

{ #category : #'as yet unclassified' }
GtInstall >> gtJsonFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Startup Script';
		priority: 1;
		actionButtonIcon: BrGlamorousIcons save
			tooltip: 'Write Script'
			action: [ :aButton :aTab | self startupScript: contents ];
		aptitude: [ BrGlamorousCodeEditorAptitude new
				when: BrEditorTextChanged
				do: [ :val | contents := val text ]
				 ];
		styler: [ StParser gtStyler];
		text: [ contents ]
]

{ #category : #'as yet unclassified' }
GtInstall >> path: aPath [ 
	path := aPath.
	contents := self contents
]

{ #category : #'as yet unclassified' }
GtInstall >> startupScript: aString [
	| file |
	file := path / 'startup.st'.
	(file exists)
		ifFalse: [ file createFile ].
	file gtSaveContents: aString
]
