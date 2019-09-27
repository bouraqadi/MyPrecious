Class {
	#name : #MpRemoteExceptionWrapper,
	#superclass : #Error,
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpRemoteExceptionWrapper class >> on: exception [
	^self new
		messageText: exception description;
		yourself
]
