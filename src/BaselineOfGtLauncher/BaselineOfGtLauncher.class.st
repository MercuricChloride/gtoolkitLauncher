Class {
	#name : #BaselineOfGtLauncher,
	#superclass : #BaselineOf,
	#category : #BaselineOfGtLauncher
}

{ #category : #loading }
BaselineOfGtLauncher class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'gtLauncher' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfGtLauncher >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'GtLauncher'
		]
]
