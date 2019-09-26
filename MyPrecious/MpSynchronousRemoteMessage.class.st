Class {
	#name : #MpSynchronousRemoteMessage,
	#superclass : #MpRemoteMessage,
	#instVars : [
		'responseId',
		'senderAddress'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #communicating }
MpSynchronousRemoteMessage >> deliverBy: transporter [
	transporter deliverSynchronousMessage: self
]

{ #category : #accessing }
MpSynchronousRemoteMessage >> responseId [
	^ responseId
]

{ #category : #accessing }
MpSynchronousRemoteMessage >> responseId: anObject [
	responseId := anObject
]

{ #category : #accessing }
MpSynchronousRemoteMessage >> senderAddress [
	^ senderAddress
]

{ #category : #accessing }
MpSynchronousRemoteMessage >> senderAddress: anObject [
	senderAddress := anObject
]
