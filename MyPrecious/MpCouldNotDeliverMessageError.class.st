Class {
	#name : 'MpCouldNotDeliverMessageError',
	#superclass : 'MpRemoteMessagingError',
	#category : 'MyPrecious-Kernel',
	#package : 'MyPrecious',
	#tag : 'Kernel'
}

{ #category : 'accessing' }
MpCouldNotDeliverMessageError >> defaultMessageText [
	^'Could not deliver remote message '
]
