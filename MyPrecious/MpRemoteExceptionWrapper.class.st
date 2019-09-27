Class {
	#name : #MpRemoteExceptionWrapper,
	#superclass : #MpRemoteMessagingError,
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpRemoteExceptionWrapper class >> on: exception [
	^self new
		messageText: exception messageText;
		yourself
]

{ #category : #accessing }
MpRemoteExceptionWrapper >> description [
	^String streamContents: [ : str|
		str << 'Remote message '.
		self printSelectorOn: str.
		str << ' raised exception on the target']
]
