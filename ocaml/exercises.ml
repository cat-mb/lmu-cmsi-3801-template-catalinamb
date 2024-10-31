exception Negative_Amount

let change amount =
  if amount < 0 then
    raise Negative_Amount
  else
    let denominations = [25; 10; 5; 1] in
    let rec aux remaining denominations =
      match denominations with
      | [] -> []
      | d :: ds -> (remaining / d) :: aux (remaining mod d) ds
    in
    aux amount denominations

let rec first_then_apply input_list condition transform =
  match input_list with
  | [] -> None
  | current_element :: remaining_elements ->
      if condition current_element then
        Some (transform current_element)
      else
        first_then_apply remaining_elements condition transform


let non_empty s = String.length s > 0;;
let lower s = String.lowercase_ascii s;;
let length_greater_than_3 s = String.length s > 3;;
let square n = n * n;;

let rec powers_generator base =
  let rec aux power =
    fun () ->
      if power > (1 lsl 100) then Seq.Nil
      else Seq.Cons (power, aux (power * base))
  in
  aux 1

let meaningful_line_count (file_name : string) : int =
  try
    let in_channel = open_in file_name in
    let rec count_lines count =
      try
        let line = input_line in_channel in
        let trimmed_line = String.trim line in
        if trimmed_line = "" || String.length trimmed_line > 0 && trimmed_line.[0] = '#' then
          count_lines count
        else
          count_lines (count + 1)
      with
      | End_of_file -> close_in in_channel; count
    in
    count_lines 0
  with
  | Sys_error _ -> raise (Sys_error ("File not found: " ^ file_name))

type shape =
  | Sphere of float  
  | Box of float * float * float 

let volume (s : shape) : float =
  match s with
  | Sphere r -> (4.0 /. 3.0) *. 3.141592653589793 *. r ** 3.0  
  | Box (w, l, d) -> w *. l *. d  

let surface_area (s : shape) : float =
  match s with
  | Sphere r -> 4.0 *. 3.141592653589793 *. r ** 2.0 
  | Box (w, l, d) -> 2.0 *. (w *. l +. w *. d +. l *. d) 

type 'a binary_search_tree =
  | Empty
  | Node of 'a * 'a binary_search_tree * 'a binary_search_tree

let rec size = function
  | Empty -> 0
  | Node (_, left, right) -> 1 + size left + size right

let rec insert data tree =
  match tree with
  | Empty -> Node (data, Empty, Empty)
  | Node (x, left, right) ->
      if data < x then Node (x, insert data left, right)
      else if data > x then Node (x, left, insert data right)
      else tree  

let rec contains data tree =
  match tree with
  | Empty -> false
  | Node (x, left, right) ->
      if data < x then contains data left
      else if data > x then contains data right
      else true  

let rec inorder tree =
  match tree with
  | Empty -> []
  | Node (x, left, right) -> inorder left @ [x] @ inorder right