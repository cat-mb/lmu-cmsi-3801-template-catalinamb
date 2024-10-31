import { open } from "node:fs/promises"

export function change(amount: bigint): Map<bigint, bigint> {
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let counts: Map<bigint, bigint> = new Map()
  let remaining = amount
  for (const denomination of [25n, 10n, 5n, 1n]) {
    counts.set(denomination, remaining / denomination)
    remaining %= denomination
  }
  return counts
}

export function firstThenApply<InputType, OutputType>(
  inputArray: InputType[], 
  condition: (element: InputType) => boolean, 
  transformFunction?: (element: InputType) => OutputType
): OutputType | undefined {
  const matchingElement = inputArray.find(condition); 

  if (matchingElement && transformFunction) {
    return transformFunction(matchingElement);
  }

  return undefined;
}

export function* powersGenerator(base: bigint): Generator<bigint> {
  let power: bigint = 1n; 

  while (true) {
    yield power; 
    power *= base; 
    if (power > 2n ** 100n) break; 
  }
}

export async function meaningfulLineCount(filename: string): Promise<number> {
  let meaningfulLineCount = 0;

  try {
    const file = await open(filename, "r");
    for await (const line of file.readLines()) {
      const trimmedLine = line.trim();
      if (trimmedLine && !trimmedLine.startsWith("#")) {
        meaningfulLineCount++;
      }
    }
  } catch (error) {
    if (error instanceof Error) {
      throw new Error(`Error reading file: ${error.message}`);
    } else {
      throw new Error("Error reading file: Unknown error occurred");
    }
  }

  return meaningfulLineCount;
}

export type Shape = 
    | { kind: "Sphere"; radius: number }
    | { kind: "Box"; width: number; length: number; depth: number };

export function volume(shape: Shape): number {
    switch (shape.kind) {
        case "Sphere":
            return (4 / 3) * Math.PI * Math.pow(shape.radius, 3);
        case "Box":
            return shape.width * shape.length * shape.depth;
        default:
            throw new Error("Shape type not supported for volume calculation");
    }
}

export function surfaceArea(shape: Shape): number {
    switch (shape.kind) {
        case "Sphere":
            return 4 * Math.PI * Math.pow(shape.radius, 2);
        case "Box":
            const { width, length, depth } = shape;
            return 2 * (width * length + width * depth + length * depth);
        default:
            throw new Error("Shape type not supported for surface area calculation");
    }
}

export interface BinarySearchTree<T> {
  size(): number;
  insert(data: T): BinarySearchTree<T>;
  contains(data: T): boolean;
  inorder(): Generator<T>;
}

export class Empty<T> implements BinarySearchTree<T> {
  size(): number {
    return 0;
  }

  insert(data: T): BinarySearchTree<T> {
    return new Node(data, this, this);
  }

  contains(): boolean {
    return false; 
  }

  *inorder(): Generator<T> {
  }

  toString(): string {
    return "()";
  }
  
}

export class Node<T> implements BinarySearchTree<T> {
  constructor(
    private data: T,
    private left: BinarySearchTree<T>,
    private right: BinarySearchTree<T>
  ) {}

  size(): number {
    return 1 + this.left.size() + this.right.size(); 
  }

  insert(data: T): BinarySearchTree<T> {
    if (data < this.data) {
      return new Node(this.data, this.left.insert(data), this.right);
    } else if (data > this.data) {
      return new Node(this.data, this.left, this.right.insert(data));
    }
    return this; 
  }

  contains(data: T): boolean {
    if (data < this.data) {
      return this.left.contains(data);
    } else if (data > this.data) {
      return this.right.contains(data);
    }
    return true; 
  }

  *inorder(): Generator<T> {
    yield* this.left.inorder();  
    yield this.data;            
    yield* this.right.inorder(); 
  }

  toString(): string {
    const leftStr = this.left.toString();
    const rightStr = this.right.toString();
    return `(${leftStr}${this.data}${rightStr})`.replace(/\(\)/g, ""); 
  }
  
}
