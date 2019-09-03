Class {
	#name : #MpTcpMiddleware,
	#superclass : #MpMiddleware,
	#instVars : [
		'server'
	],
	#category : #MyPreciousTcp
}

{ #category : #communicating }
MpTcpMiddleware >> channelClass [
	^MpTcpChannel
]

{ #category : #initialization }
MpTcpMiddleware >> channelFactoryClass [
	^MpTcpChannelFactory
]

{ #category : #communicating }
MpTcpMiddleware >> communicateVia: stream [
	self channelFactory communicateVia: stream
]

{ #category : #initialization }
MpTcpMiddleware >> initialize [
	super initialize.
	server := self serverClass new. 
	server withCommunicationStreamDo: [ : stream | 
			self communicateVia: stream ].
]

{ #category : #testing }
MpTcpMiddleware >> isStarted [
	^self server isStarted
]

{ #category : #testing }
MpTcpMiddleware >> isStopped [
	^self server isStopped
]

{ #category : #initialization }
MpTcpMiddleware >> localHostAddress [
	^NetNameResolver localHostAddress
]

{ #category : #initialization }
MpTcpMiddleware >> port: portNumber [
	self server port: portNumber.
	address := MpIpFullAddress ip: self localHostAddress port: portNumber 
]

{ #category : #accessing }
MpTcpMiddleware >> server [
	^server
]

{ #category : #initialization }
MpTcpMiddleware >> serverClass [
	^NeTcpServer 
]

{ #category : #activity }
MpTcpMiddleware >> start [
	^self server start
]

{ #category : #activity }
MpTcpMiddleware >> stop [
	^self server stop
]
