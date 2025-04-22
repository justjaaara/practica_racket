#lang racket

(struct client (id username password balance))
(struct seller (id username password))
(struct product (id name price stock seller-id))
(struct cart-item (id name price quantity))


(define users
  (make-parameter
   (list
    (client 1 "luis_goez" "1411" 1000000)
    (client 2 "felipe" "123" 500000)
    (client 3 "pablo" "1234" 100000)
    (seller 1 "juangui" "123"))))

(define inventory
  (make-parameter
   (list
    (product 101 "Camiseta negra" 30000 10 1)
    (product 102 "Gorra azul" 15000 20 1)
    (product 103 "Zapatos deportivos" 120000 5 1))))

(define cart (make-parameter '()))


(define (login username password)
  (define (check-user u)
    (cond
      [(client? u)
       (if (and (string=? (client-username u) username)
                (string=? (client-password u) password))
           (list "client" u)
           #f)]
      [(seller? u)
       (if (and (string=? (seller-username u) username)
                (string=? (seller-password u) password))
           (list "seller" u)
           #f)]
      [else #f]))
  (let loop ((lst (users)))
    (cond
      [(empty? lst) #f]
      [(check-user (first lst)) => (lambda (res) res)]
      [else (loop (rest lst))])))

(define (view_inventory user-type)
  (define inv (inventory))
  (if (null? inv)
      (displayln "El inventario está vacío.")
      (for-each
       (lambda (p)
         (cond
           [(string=? user-type "seller")
            (printf "ID: ~a | Producto: ~a | Precio: ~a | Stock: ~a | Vendedor ID: ~a~n"
                    (product-id p)
                    (product-name p)
                    (product-price p)
                    (product-stock p)
                    (product-seller-id p))]
           [(string=? user-type "client")
            (printf "ID: ~a | Producto: ~a | Precio: ~a~n"
                    (product-id p)
                    (product-name p)
                    (product-price p))]))
       inv)))


(define (add_inventory)
  (display "ID del producto: ")
  (define id (read))
  (read-line)
  (display "Nombre del producto: ")
  (define name (read-line))
  (display "Precio del producto: ")
  (define price (read))
  (read-line)
  (display "Cantidad en stock: ")
  (define stock (read))
  (read-line)
  (display "ID del vendedor: ")
  (define seller-id (read))
  (read-line)
  (define new-product (product id name price stock seller-id))
  (inventory (cons new-product (inventory)))
  (displayln "Producto añadido exitosamente."))

(define (remove_inventory)
  (display "Ingrese el ID del producto a eliminar: ")
  (define id (read))
  (read-line)
  (define new-inv
    (filter (lambda (p) (not (= (product-id p) id))) (inventory)))
  (inventory new-inv)
  (displayln "Producto eliminado exitosamente."))

(define (add_cart)
  (display " Ingrese el ID del producto a agregar: ")
  (define id (read))
  (read-line)
  (display " Ingrese la cantidad que quiere llevar del producto: ")
  (define quantity (read))
  (read-line)
  (define inv (inventory))
  (define product (findf (lambda (p) ( = ( product-id p) id)) inv))
  (if product
      (if ( >= ( product-stock product) quantity)
          (let* ([c (cart)]
                 [existing (findf (lambda (item) (= (cart-item-id item) id)) c)])
            (if existing
                
                ;; ACTUALIZAMOS LA CANTIDAD SI EL PRODUCTO YA ESTA EN EL CARRITO
                (let ((updated-cart
                       (map (lambda (item)
                              (if (= (cart-item-id item) id)
                                  (cart-item id (cart-item-name item) (cart-item-price item)
                                             (+ (cart-item-quantity item) quantity))
                                  item))
                            c)))
                  (cart updated-cart)
                  (displayln "Cantidad actualizada en el carrito."))

                ;; Agregar nuevo item al carrito
                (let ((new-item (cart-item id (product-name product)
                                           (product-price product) quantity)))
                  (cart (cons new-item c))
                  (displayln "Producto agregado al carrito"))))
          (displayln "No hay suficiente stock disponible"))
      (displayln " Producto no encontrado, ingrese un id de producto valido")))

(define (remove_cart)
  (displayln "Ingrese el ID del producto que quiere eliminar del carrito: ")
  (define id (read))
  (read-line)
  (define c (cart))
  (define item (findf ( lambda (x) (= ( cart-item-id x) id)) c))
  (if item
      (begin
        (display "Ingrese la cantidad que desea eliminar del producto: ")
        (let* ([quantity_to_delete (read)])
        (read-line)
        (let ([updated-cart
               (if (>= quantity_to_delete (cart-item-quantity item))
                   ;; SI LA CANTIDAD INGRESADA ES IGUAL O MAYOR A LA QUE HAY DEL PRODUCTO EN EL CARRITO SE ELIMINA POR COMPLETO
                   (filter (lambda (x) (not ( = (cart-item-id x ) id))) c)
                   ;; restamos la cantidad y actualizamos el item
                   (map (lambda (x)
                          (if (= (cart-item-id x) id)
                              (cart-item id
                                         (cart-item-name x)
                                         (cart-item-price x)
                                         (- (cart-item-quantity x) quantity_to_delete))
                              x))
                        c))])
          (cart updated-cart)
          (displayln "Producto actualizado en el carrito"))))
      (displayln "Ese producto no esta en el carrito, ingrese un id correcto")))
      

(define (view_cart)
  (define c (cart))
  (if (null? c)
      (displayln "El carrito esta vacio.")
      (begin
        (displayln "------------CARRITO------------")
        (for-each
         (lambda (item)
           (printf "ID: ~a | Producto: ~a | Precio: ~a | Cantidad: ~a~n"
                   (cart-item-id item)
                   (cart-item-name item)
                   (cart-item-price item)
                   (cart-item-quantity item)))
         c))))
        
(define (pay client-user)
  (define c (cart))
  (if (null? c)
      (displayln "El carrito está vacío.")
      (let* ([total (apply + (map (lambda (item)
                                    (* (cart-item-price item) (cart-item-quantity item)))
                                  c))]
             [saldo (client-balance client-user)])
        (if (< saldo total)
            (begin
              (printf "Saldo insuficiente. Total: ~a, Tu saldo: ~a~n" total saldo))
            (begin
              ;; Descontar stock del inventario
              (let* ([updated-inv
                      (map (lambda (prod)
                             (let ([match (findf (lambda (item)
                                                   (= (cart-item-id item) (product-id prod))) c)])
                               (if match
                                   (product (product-id prod)
                                            (product-name prod)
                                            (product-price prod)
                                            (- (product-stock prod) (cart-item-quantity match))
                                            (product-seller-id prod))
                                   prod)))
                           (inventory))]

                     [new-users
                      (map (lambda (u)
                             (if (and (client? u)
                                      (= (client-id u) (client-id client-user)))
                                 (client (client-id u)
                                         (client-username u)
                                         (client-password u)
                                         (- (client-balance u) total))
                                 u))
                           (users))]

                     [new-client (findf (lambda (u)
                                          (and (client? u)
                                               (= (client-id u) (client-id client-user))))
                                        new-users)])
                (inventory updated-inv)
                (users new-users)
                (cart '())
                (displayln "Pago Exitoso")
                (printf "Compra realizada por ~a~n" total)
                (printf "Saldo actualizado: ~a~n" (client-balance new-client))))))))

(define (shopping_cart)
  (let loop ()
    (displayln "\n--- Tienda Fe_Lu_Pa ---")
    (displayln "1. Iniciar sesión")
    (displayln "2. Salir")
    (display "Ingresa lo que deseas hacer: ")
    (define option (read))
    (read-line)
    (cond
      [(= option 1)
       (displayln "\nBienvenido a Tienda Fe_Lu_Pa")
       (display "Usuario: ")
       (define username (read-line))
       (display "Contraseña: ")
       (define password (read-line))
       (define result (login username password))
       (if result
           (let* ([type (first result)]
                  [data (second result)]
                  [msj (if (string=? type "client")
                           (string-append "Bienvenido " type ": " (client-username data))
                           (string-append "Bienvenido " type ": " (seller-username data)))])
             (displayln "\nInicio de sesión exitoso.")
             (displayln msj)
             (cond
               [(string=? type "seller")
                (let seller-loop ()
                  (displayln "\nMenú Vendedor:")
                  (displayln "1. Visualizar inventario")
                  (displayln "2. Añadir al inventario")
                  (displayln "3. Eliminar del inventario")
                  (displayln "4. Cerrar sesión")
                  (display "Ingrese la opción que deseas: ")
                  (define option2 (read))
                  (read-line)
                  (cond
                    [(= option2 1) (view_inventory "seller") (seller-loop)]
                    [(= option2 2) (add_inventory) (seller-loop)]
                    [(= option2 3) (remove_inventory) (seller-loop)]
                    [(= option2 4) (displayln "Sesión cerrada.")]
                    [else (displayln "Opción inválida.") (seller-loop)]))]
               [else
                (let client-loop ()
                  (displayln "\nMenú Cliente:")
                  (displayln "1. Visualizar productos")
                  (displayln "2. Visualizar carrito")
                  (displayln "3. Añadir al carrito")
                  (displayln "4. Eliminar del carrito")
                  (displayln "5. Pagar carrito")
                  (displayln "6. Cerrar sesión")
                  (display "Ingrese la opción que deseas: ")
                  (define option2 (read))
                  (read-line)
                  (cond
                    [(= option2 1) (view_inventory "client") (client-loop)]
                    [(= option2 2) (view_cart) (client-loop)]
                    [(= option2 3) (add_cart) (client-loop)]
                    [(= option2 4) (remove_cart) (client-loop)]
                    [(= option2 5) (pay data) (client-loop)]
                    [(= option2 6) (displayln "Sesión cerrada.")]
                    [else (displayln "Opción inválida.") (client-loop)]))]))
           (displayln "Credenciales inválidas"))
       (loop)]
      [(= option 2)
       (displayln "Chao")]
      [else
       (displayln "ERROR: Opción no válida")
       (loop)])))

(shopping_cart)
