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
	#category : #'GtLauncher-Buttons'
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

{ #category : #'as yet unclassified' }
GtRelease >> downloadFor: aSymbol [
	| link |
	link := self perform: aSymbol.

	^ ZnClient new
		beBinary;
		beOneShot;
		url: (ZnUrl fromString: link);
		downloadTo: FileLocator imageDirectory / 'foo'
]

{ #category : #accessing }
GtRelease >> downloadReleaseFor: aSymbol [
	| tag name link download output |
	^ [ tag := raw at: 'tag_name'.

	name := Date today mmddyyyy , '-' , tag.

	self
		assert: (GtlConfiguration imagesPath / name) exists not
		description: 'Already exists!'.

	link := self perform: aSymbol.

	output := GtlConfiguration imagesPath / name.

	download := GtlConfiguration imagesPath / (name , '.zip').

	ZnOptions globalDefault clone
		at: #queryKeyValueSafeSet put: ZnOptions queryKeyValueSafeSet \ '/;';
		during: [ link asUrl saveContentsToFile: download ].
		
	(ZipArchive new readFrom: download) extractAllTo: output.
	
	download ensureDelete ] asAsyncPromise
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
