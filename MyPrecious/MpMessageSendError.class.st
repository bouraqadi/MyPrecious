Class {
	#name : #MpMessageSendError,
	#superclass : #Error,
	#instVars : [
		'message'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpMessageSendError >> message [
	^ message
]

{ #category : #accessing }
MpMessageSendError >> message: anObject [
	message := anObject
]

{ #category : #printing }
MpMessageSendError >> printSelectorOn: stream [
	self message ifNil: [ ^self ].
	stream
		nextPut: $#;
		nextPutAll: self message selector
]
