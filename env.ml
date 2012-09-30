open Type

module L = Type.L
module M = Type.M
module H = Type.H

let globals : (M.key, value ref) H.t =
  H.create 1
;;

let empty =
  M.empty
;;

let is_bound var env =
  M.mem var env || H.mem globals var
;;

let get_ref var env =
  try M.find var env with
    | Not_found -> H.find globals var
;;

let get_var var env =
  try !(get_ref var env) with
    | Not_found ->
        failwith ("get_var: cannot get undefined variable " ^ var)
;;

let def_local var value env =
  M.add var (ref value) env
;;

let def_global var value =
  H.add globals var (ref value)
;;

let set_var var value env =
  try get_ref var env := value with
    | Not_found ->
        failwith ("set_var: cannot set undefined variable " ^ var)
;;

let bind_locals init_env var_assoc =
  L.fold_left
    (fun m (k, v) -> def_local k v m)
    init_env
    var_assoc
;;

let bind_globals var_assoc =
  L.iter
    (fun (k, v) -> def_global k v)
    var_assoc
;;
