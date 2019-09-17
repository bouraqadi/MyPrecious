Class {
	#name : #MpRemoteMessageSendError,
	#superclass : #Error,
	#instVars : [
		'remoteException',
		'message'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #accessing }
MpRemoteMessageSendError >> description [
	^String streamContents: [ : str |
		str 
			<< 'Remote message #'; 
			<< self message selector;
			<< ' signaled ';
			<< self remoteException description
	 ]
]

{ #category : #accessing }
MpRemoteMessageSendError >> message [
	^ message
]

{ #category : #accessing }
MpRemoteMessageSendError >> message: anObject [
	message := anObject
]

{ #category : #accessing }
MpRemoteMessageSendError >> remoteException [
	^ remoteException
]

{ #category : #accessing }
MpRemoteMessageSendError >> remoteException: anObject [
	remoteException := anObject
]
