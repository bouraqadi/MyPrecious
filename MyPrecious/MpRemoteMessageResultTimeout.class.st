Class {
	#name : #MpRemoteMessageResultTimeout,
	#superclass : #Error,
	#instVars : [
		'resultPromise',
		'message'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpRemoteMessageResultTimeout >> description [
	^'Timeout while waiting for result of remote message #', self message selector
]

{ #category : #accessing }
MpRemoteMessageResultTimeout >> message [
	^ message
]

{ #category : #accessing }
MpRemoteMessageResultTimeout >> message: anObject [
	message := anObject
]

{ #category : #accessing }
MpRemoteMessageResultTimeout >> resultPromise [
	^ resultPromise
]

{ #category : #accessing }
MpRemoteMessageResultTimeout >> resultPromise: anObject [
	resultPromise := anObject
]
