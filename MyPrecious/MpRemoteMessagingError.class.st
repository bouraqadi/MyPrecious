Class {
	#name : #MpRemoteMessagingError,
	#superclass : #Error,
	#instVars : [
		'message',
		'originalException'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpRemoteMessagingError >> defaultMessageText [
	self subclassResponsibility
]

{ #category : #accessing }
MpRemoteMessagingError >> description [
	^String streamContents: [: stream |
		stream << super description.
		self printSelectorOn: stream.
		stream
			<< ' - ';
			<< self originalException description]
]

{ #category : #accessing }
MpRemoteMessagingError >> message [
	^ message
]

{ #category : #accessing }
MpRemoteMessagingError >> message: anObject [
	message := anObject
]

{ #category : #accessing }
MpRemoteMessagingError >> messageText [
	^super messageText ifEmpty: [ 
		self defaultMessageText ]
]

{ #category : #accessing }
MpRemoteMessagingError >> originalException [
	^ originalException
]

{ #category : #accessing }
MpRemoteMessagingError >> originalException: anObject [
	originalException := anObject
]

{ #category : #printing }
MpRemoteMessagingError >> printSelectorOn: stream [
	self message ifNil: [ ^self ].
	stream
		nextPut: $#;
		nextPutAll: self message selector
]
