Class {
	#name : #GtInstall,
	#superclass : #Object,
	#instVars : [
		'path',
		'contents',
		'activeProcess'
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
GtInstall >> installedOn [
	^ path creationTime asDate
]

{ #category : #'as yet unclassified' }
GtInstall >> name [
	^ (path fullName splitOn: '/') last
]

{ #category : #'as yet unclassified' }
GtInstall >> path: aPath [ 
	path := aPath.
	contents := self contents
]

{ #category : #'as yet unclassified' }
GtInstall >> run [
	| process |
	activeProcess
		ifNotNil: [ activeProcess isTerminated ifTrue: [ activeProcess := nil ] ].
	self
		assert: activeProcess isNil
		description: 'Trying to run another instance of gt, but we already have one opened!'.
	Smalltalk os isMacOSX
		ifTrue: [ process := GtExternalProcessBuilder new
					command: 'open';
					arg: (path / 'GlamorousToolkit.app') pathString;
					pipeStdout;
					pipeStderr ].
	activeProcess := process spawn
]

{ #category : #'as yet unclassified' }
GtInstall >> startupScript: aString [
	| file |
	file := path / 'startup.st'.
	(file exists)
		ifFalse: [ file createFile ].
	file gtSaveContents: aString
]
