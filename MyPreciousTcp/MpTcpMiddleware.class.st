Class {
	#name : #MpTcpMiddleware,
	#superclass : #MpMiddleware,
	#category : #MyPreciousTcp
}

{ #category : #initialization }
MpTcpMiddleware >> localHostAddress [
	^NetNameResolver localHostAddress
]

{ #category : #initialization }
MpTcpMiddleware >> port: portNumber [
	self transporter port: portNumber.
	address := MpIpFullAddress ip: self localHostAddress port: portNumber 
]

{ #category : #initialization }
MpTcpMiddleware >> transporterClass [
	^MpTcpConnectedTransporter
]
