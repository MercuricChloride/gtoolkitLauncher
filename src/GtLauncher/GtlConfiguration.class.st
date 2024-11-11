"
I am a singleton that represents the configuration for the glamorous toolkit launcher.

"
Class {
	#name : #GtlConfiguration,
	#superclass : #Object,
	#classInstVars : [
		'releaseEndpoint',
		'resultsPerPage'
	],
	#category : #'GtLauncher-Models'
}

{ #category : #accessing }
GtlConfiguration class >> getReleases [
	| endpoint res resArr |
	endpoint := self releaseEndpoint.

	res := ZnClient new get: endpoint.
	resArr := NeoJSONReader fromString: res.

	^ (resArr collect: [:release | 
		(release at: 'tag_name') -> (GtRelease newFrom: release)]) asDictionary
]

{ #category : #'as yet unclassified' }
GtlConfiguration class >> imagesPath [
	|home path|
	home := (Smalltalk os environment at: 'HOME') asFileReference.
	path := home / 'gtoolkit-images'.
	
	path exists ifFalse: [ path createDirectory ].
	
	^ path
]

{ #category : #'as yet unclassified' }
GtlConfiguration class >> releaseEndpoint [
	^ releaseEndpoint ifNil: ['https://api.github.com/repos/feenkcom/gtoolkit/releases?per_page=' , (self resultsPerPage asString)]
]

{ #category : #'as yet unclassified' }
GtlConfiguration class >> resultsPerPage [
	^ resultsPerPage ifNil: [5]
]
