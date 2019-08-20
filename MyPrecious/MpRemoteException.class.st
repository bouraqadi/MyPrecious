Class {
	#name : #MpRemoteException,
	#superclass : #Error,
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpRemoteException class >> on: exception [
	^self new
		messageText: exception messageText;
		yourself
]

{ #category : #accessing }
MpRemoteException >> description [
	^'Exception occured upon performing a message on a remote object'
]
