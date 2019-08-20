Class {
	#name : #MpInboundChannel,
	#superclass : #MpChannel,
	#category : #'MyPrecious-Kernel'
}

{ #category : #receiving }
MpInboundChannel >> receiveObject: remoteMessage [
	|  result response |
	[
		result := remoteMessage send. 
		response := MpNormalResponse id: remoteMessage resultId result: result.
	] on: Exception
	  do: [ : exception |
		response := MpExceptionResponse id: remoteMessage resultId exception: exception.
		].
	self sendObject: response


]
