"
I represent a github release for glamorous toolkit.

I have methods to extract the download links for the respective architectures
"
Class {
	#name : #GtRelease,
	#superclass : #Object,
	#instVars : [
		'raw'
	],
	#category : #'GtLauncher-Models'
}

{ #category : #'as yet unclassified' }
GtRelease class >> newFrom: aJsonDict [
	^ self new
		raw: aJsonDict.
]

{ #category : #'as yet unclassified' }
GtRelease >> assets [
	^ raw at: 'assets'
]

{ #category : #accessing }
GtRelease >> downloadReleaseFor: aSymbol [
	| tag name link download output |
	^ [ tag := raw at: 'tag_name'.

	name := (Date today dayOfYear asString) , '-' , tag.

	self
		assert: (GtlConfiguration imagesPath / name) exists not
		description: 'Already exists!'.

	link := self perform: aSymbol.

	output := GtlConfiguration imagesPath / name.

	download := GtlConfiguration imagesPath / (name , '.zip').

	ZnOptions globalDefault clone
		at: #queryKeyValueSafeSet put: ZnOptions queryKeyValueSafeSet \ '/;';
		during: [ link asUrl saveContentsToFile: download ].
		
	"(ZipArchive new readFrom: download) extractAllTo: output."
	
	"download ensureDelete" ] asAsyncPromise
]

{ #category : #'as yet unclassified' }
GtRelease >> gtDownloadForLinux: anAction [
	<gtAction>
	^ anAction button
		priority: 11;
		tooltip: 'Linux x86';
		label: 'Linux x86';
		icon: BrGlamorousVectorIcons down;
		action: [ :aButton | (self downloadReleaseFor: #linux) inspect ]
]

{ #category : #'as yet unclassified' }
GtRelease >> gtDownloadForMac: anAction [
	<gtAction>
	^ anAction button
		priority: 11;
		tooltip: 'Mac Arm';
		label: 'Mac Arm';
		icon: BrGlamorousVectorIcons down;
		action: [ :aButton | (self downloadReleaseFor: #macArm) inspect ]
]

{ #category : #'as yet unclassified' }
GtRelease >> linux [
	"The download link for linux x86"
	^ self releaseFor: self linuxRegex
]

{ #category : #'as yet unclassified' }
GtRelease >> linuxRegex [
	^ '.*-Linux-x86.*\.zip$'
]

{ #category : #'as yet unclassified' }
GtRelease >> macArm [
	"The download link for mac-arm"
	^ self releaseFor: self macArmRegex
]

{ #category : #'as yet unclassified' }
GtRelease >> macArmRegex [
	^ '.*-MacOS-aarch.*\.zip$'
]

{ #category : #'as yet unclassified' }
GtRelease >> raw: aJsonDict [ 
	raw := aJsonDict
]

{ #category : #'as yet unclassified' }
GtRelease >> releaseFor: regex [
	|asset|
	asset := self assets detect: [ :each | (each at: 'name') matchesRegex: regex ].
	self assert: asset isNotNil description: 'Couldn''t find a release for build!'.
	^ asset at: 'browser_download_url'
]
