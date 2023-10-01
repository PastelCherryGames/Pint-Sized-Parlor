extends AnimatedSprite2D

var move_cooldown_timer: float = -1.0
var move_cooldown_length: float = 0.4
var start_position: Vector2
var target_position: Vector2
var anim_num: int = 1
var raycast_checked: bool = false

func _ready():
	pass

func _physics_process(delta):
	if move_cooldown_timer >= 0:
		move_cooldown_timer -= delta
		if !raycast_checked:
			raycast_checked = true
			move()
		elif target_position != start_position:
			position = start_position.lerp(target_position, 1.0 - (move_cooldown_timer / move_cooldown_length))
			
		if move_cooldown_timer < 0.0 and target_position != start_position:
			position = target_position
	else:
		if Input.is_action_pressed("ui_right"):
			pre_move(Vector2(16, 0))
			play_anim("walk_right_" + str(anim_num))
		elif Input.is_action_pressed("ui_left"):
			pre_move(Vector2(-16, 0))
			play_anim("walk_left_" + str(anim_num))
		elif Input.is_action_pressed("ui_down"):
			pre_move(Vector2(0, 16))
			play_anim("walk_down_" + str(anim_num))
		elif Input.is_action_pressed("ui_up"):
			pre_move(Vector2(0, -16))
			play_anim("walk_up_" + str(anim_num))

func play_anim(anim_name: String):
	animation = anim_name
	play()
	if anim_num == 1:
		anim_num = 2
	else:
		anim_num = 1

func pre_move(direction: Vector2):
	move_cooldown_timer = move_cooldown_length
	get_node("RayCast2D").target_position = direction
	raycast_checked = false

func move():
	var raycast: RayCast2D = get_node("RayCast2D")
	if raycast.is_colliding():
		if raycast.get_collider().is_in_group("Wall"):
			target_position = start_position
		elif raycast.get_collider().is_in_group("Interactable"):
			target_position = start_position
	else:
		start_position = position
		target_position = Vector2(
			position.x + raycast.target_position.x,
			position.y + raycast.target_position.y
		)








#    Rigidbody2D playerRigidbody;
#    SpriteRenderer playerRenderer;
#    public GameObject levelManager;
#    public GameObject currentSoil;
#    public float moveCooldownTimer = -1.0f;
#    public float moveCooldownLength = 0.75f;
#
#    public bool isWateringAllowed;
#    public bool isFertilizingAllowed;
#    public bool isPlantingAllowed;
#
#    public Vector2 startPosition;
#    public Vector2 targetPosition;
#    public Vector2 arcControlPosition;
#    public float arcHeight = 0.5f;
#
#    public Vector2 vectorA;
#    public Vector2 vectorB;

#    void Start()
#    {
#        playerRigidbody = GetComponent<Rigidbody2D>();
#        playerRenderer = GetComponent<SpriteRenderer>();
#        CheckAllowedActions();
#    }
#
#    void Update()
#    {
#        if (moveCooldownTimer >= 0) {
#            moveCooldownTimer -= Time.deltaTime;
#            vectorA = Vector2.Lerp(startPosition, arcControlPosition, 1.0f - (moveCooldownTimer / moveCooldownLength));
#            vectorB = Vector2.Lerp(arcControlPosition, targetPosition, 1.0f - (moveCooldownTimer / moveCooldownLength));
#            transform.position = Vector2.Lerp(vectorA, vectorB, 1.0f - (moveCooldownTimer / moveCooldownLength));
#
#            if (moveCooldownTimer < 0) {
#                levelManager.GetComponent<LevelManager>().OnMove();
#            }
#        } else {
#            float movement = Input.GetAxis("Horizontal");
#            if (movement > 0.5) {
#                Move(ArrowDirection.Right);
#            } else if (movement < -0.5) {
#                Move(ArrowDirection.Left);
#            }
#        }
#    }
#
#    void Move(ArrowDirection arrowDirection)
#    {
#        if (levelManager.GetComponent<LevelManager>().actionsLeft > 0) {
#            isWateringAllowed = false;
#            isFertilizingAllowed = false;
#            isPlantingAllowed = false;
#            moveCooldownTimer = moveCooldownLength;
#
#            int currentSpaceLayer = LayerMask.NameToLayer("Current Space");
#            int soilLayer = LayerMask.NameToLayer("Soil");
#            int layerMask = (1 << soilLayer);
#            Vector2 direction = new Vector2(1.0f, 0.0f);
#            if (arrowDirection == ArrowDirection.Left) {
#                direction = new Vector2(-1.0f, 0.0f);
#            }
#            RaycastHit2D hit = Physics2D.Raycast(playerRigidbody.position, direction, 1.0f, layerMask);
#            if (hit.collider != null)
#            {
#                levelManager.GetComponent<LevelManager>().CheckButtons();
#                startPosition = playerRigidbody.position;
#                targetPosition = new Vector2(playerRigidbody.position.x + direction.x, playerRigidbody.position.y);
#                arcControlPosition = new Vector2(playerRigidbody.position.x + (direction.x/2), arcHeight);
#
#                if (arrowDirection == ArrowDirection.Left) {
#                    playerRenderer.flipX = false;
#                } else if (arrowDirection == ArrowDirection.Right) {
#                    playerRenderer.flipX = true;
#                }
#
#                currentSoil.layer = soilLayer;
#                currentSoil = hit.transform.gameObject;
#                currentSoil.layer = currentSpaceLayer;
#
#                CheckAllowedActions();
#            } else {
#                moveCooldownTimer = -1.0f;
#                CheckAllowedActions();
#            }
#        }
#    }
#
#    public void CheckAllowedActions() {
#        if (
#            moveCooldownTimer < 0
#            && currentSoil.GetComponent<SoilController>().ownPlant != null
#            && currentSoil.GetComponent<SoilController>().ownPlant.GetComponent<PlantController>().waterNeeded > 0
#        ) {
#            isWateringAllowed = true;
#        } else {
#            isWateringAllowed = false;
#        }
#
#        if (
#            moveCooldownTimer < 0
#            && currentSoil.GetComponent<SoilController>().ownPlant != null
#            && currentSoil.GetComponent<SoilController>().ownPlant.GetComponent<PlantController>().fertilizerNeeded > 0
#        ) {
#            isFertilizingAllowed = true;
#        } else {
#            isFertilizingAllowed = false;
#        }
#
#        if (moveCooldownTimer < 0 && currentSoil.GetComponent<SoilController>().ownPlant == null) {
#            isPlantingAllowed = true;
#        } else {
#            isPlantingAllowed = false;
#        }
#    }
