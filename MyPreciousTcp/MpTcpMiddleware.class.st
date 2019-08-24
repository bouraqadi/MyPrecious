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

{ #category : #initialization }
MpTcpMiddleware >> initialize [
	super initialize.
	server := self serverClass new. 
	server withCommunicationStreamDo: [ : stream | 
			self channelFactory newChannel communicateVia: stream ].
]

{ #category : #initialization }
MpTcpMiddleware >> port: portNumber [
	self server port: portNumber 
]

{ #category : #accessing }
MpTcpMiddleware >> protocolClass [
	^MpTcpProtocol
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
	^server start
]

{ #category : #activity }
MpTcpMiddleware >> stop [
	^server stop
]
