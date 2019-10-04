Class {
	#name : #BaselineOfMyPrecious,
	#superclass : #BaselineOf,
	#category : #BaselineOfMyPrecious
}

{ #category : #baselines }
BaselineOfMyPrecious >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec 
			baseline: 'Equals' with: [
				spec
					repository: 'github://bouraqadi/PharoMisc' ];
			baseline: 'Concurrency' with: [
				spec
					repository: 'github://bouraqadi/PharoMisc' ];
			baseline: 'NetworkExtras' with: [
				spec
					repository: 'github://bouraqadi/PharoMisc' ].

		spec 
			repository: 'github://bouraqadi/MyPrecious';
			package: #MyPrecious with: [
				spec requires: #('Equals' 'Concurrency')];
			package: #MyPreciousTests with: [
				spec requires: #('MyPrecious')];
			package: #MyPreciousTcp with: [
				spec requires: #('MyPrecious' 'NetworkExtras')];
			package: #MyPreciousTcpTest with: [
				spec requires: #('MyPreciousTests' 'MyPreciousTcp')].
			
		spec
				group: 'kernel' with: #('MyPrecious');
				group: 'tcp' with: #('kernel' 'MyPreciousTcp');
				group: 'default' with: #('tcp' 'MyPreciousTests' 'MyPreciousTcpTest')
	].

]
