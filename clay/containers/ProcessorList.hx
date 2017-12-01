package clay.containers;


import clay.Processor;


class ProcessorList {


	public var head (default, null) : Processor;
	public var tail (default, null) : Processor;

	public var length(default, null):Int = 0;

	public function new() {}

	public function add(processor:Processor):ProcessorList {

		if (head == null) {
			head = tail = processor;
			processor.next = processor.prev = null;
		} else {
			var node:Processor = tail;
			while (node != null) {
				if (node.priority <= processor.priority){
					break;
				}

				node = node.prev;
			}

			if (node == tail) {
				tail.next = processor;
				processor.prev = tail;
				processor.next = null;
				tail = processor;
			} else if (node == null) {
				processor.next = head;
				processor.prev = null;
				head.prev = processor;
				head = processor;
			} else {
				processor.next = node.next;
				processor.prev = node;
				node.next.prev = processor;
				node.next = processor;
			}
		}

		length++;

		return this;

	}

	public function exists(processorClass:Class<Dynamic>):Bool {

		var ret:Bool = false;

		var node:Processor = head;
		while (node != null){
			if (Type.getClass(node) == processorClass){
				ret = true;
				break;
			}

			node = node.next;
		}

		return ret;

	}

	public function get(processorClass:Class<Dynamic>):Processor { 

		var ret:Processor = null;

		var node:Processor = head;
		while (node != null){
			if (Type.getClass(node) == processorClass){
				ret = node;
				break;
			}

			node = node.next;
		}

		return ret;

	}

	public function remove(processor:Processor):ProcessorList {

		if (processor == head){
			head = head.next;
			
			if (head == null) {
				tail = null;
			}
		} else if (processor == tail) {
			tail = tail.prev;
				
			if (tail == null) {
				head = null;
			}
		}

		if (processor.prev != null){
			processor.prev.next = processor.next;
		}

		if (processor.next != null){
			processor.next.prev = processor.prev;
		}

		processor.next = processor.prev = null;

		length--;

		return this;

	}

	public function update(processor:Processor):ProcessorList {

		remove(processor);
		add(processor);

		return this;

	}

	public function updateAll():ProcessorList {

		var _sortingArray:Array<Processor> = [];

		var node:Processor = head;
		while (node != null){
			_sortingArray.push(node);
			node = node.next;
		}

		clear();
		
		for (n in _sortingArray) {
			add(n);
		}

		return this;

	}

	public function clear():ProcessorList {

		var processor:Processor = null;
		while (head != null) {
			processor = head;
			head = head.next;
			processor.prev = null;
			processor.next = null;
		}

		tail = null;
		
		length = 0;

		return this;

	}

	public function toArray():Array<Processor> {

		var _arr:Array<Processor> = []; 

		var node:Processor = head;
		while (node != null){
			_arr.push(node);
			node = node.next;
		}

		return _arr;

	}

	@:noCompletion public function toString() {

		var _list:Array<String> = []; 

		var cn:String;
		var node:Processor = head;
		while (node != null){
			cn = Type.getClassName(Type.getClass(node));
			_list.push('$cn / priority: ${node.priority}');
			node = node.next;
		}

		return '[${_list.join(", ")}]';

	}

	public inline function iterator():ProcessorListIterator {

		return new ProcessorListIterator(head);

	}
	

}

@:final @:unreflective @:dce
@:access(clay.containers.EntityVector)
class ProcessorListIterator {


	public var node:Processor;


	public inline function new(head:Processor) {

		node = head;

	}

	public inline function hasNext():Bool {

		return node != null;

	}

	public inline function next():Processor {

		var n = node;
		node = node.next;
		return n;

	}


}

