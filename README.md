# ProyectoFinalMoviles
Repositorio del proyecto final de Desarrollo de aplicaciones móviles. Aplicación hecha en Flutter

START A LINE
- Tienes una configuración guardada?
  - Si si, despliega las filas guardadas previamente en un modal, deben tener un botón de editar donde
    - Si se da click se abriría el formulario lleno con la posibilidad de editarlo y se termina con el botón de DONE, si
    - Si solo se selecciona la fila no abre el formulario, solo va directo a iniciar el proceso de la fila.
  - Si no, llenar el formulario y dar click a DONE.
  - DONE abre la opción de guardar la configuración que acabas de hacer,sea porque la editaste o porque es nueva, si se guarda se juntará a la lista que se abre al dar click a configuraciones guardadas.

Formulario:
- Título
- Máximo de personas
  - Si llegas a 20 y quieres subir, aparece modal de comprar versión PRO **
- Descripción (opcional)
- Subir un archivo (opcional)
  - Requiere título
- Añadir Timer, el dueño puede editar la cantidad de tiempo tiene el usuario del frente para entrar, si no entra, se mueve 5 lugares para atras en la fila y la fila avanza
- Si el dueño no edita el timer, el default es 1 minuto
- Notificaciones, ¿Como Dueño quieres recibir una notificación cada que un usuario pase?
