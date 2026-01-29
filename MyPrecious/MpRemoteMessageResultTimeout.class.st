Class {
	#name : 'MpRemoteMessageResultTimeout',
	#superclass : 'MpRemoteMessagingError',
	#category : 'MyPrecious-Kernel',
	#package : 'MyPrecious',
	#tag : 'Kernel'
}

{ #category : 'accessing' }
MpRemoteMessageResultTimeout >> defaultMessageText [
	^'Timeout waiting for response for remote message '.

]
