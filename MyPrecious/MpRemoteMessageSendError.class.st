Class {
	#name : #MpRemoteMessageSendError,
	#superclass : #Error,
	#instVars : [
		'message'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpRemoteMessageSendError >> description [
	^'Error sending remote message #', self message selector
]

{ #category : #accessing }
MpRemoteMessageSendError >> message [
	^ message
]

{ #category : #accessing }
MpRemoteMessageSendError >> message: anObject [
	message := anObject
]
