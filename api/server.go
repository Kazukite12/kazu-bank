package api

import (
	"fmt"

	db "github.com/Kazukite12/simple-bank/db/sqlc"
	"github.com/Kazukite12/simple-bank/token"
	"github.com/Kazukite12/simple-bank/util"
	"github.com/gin-gonic/gin"
)

type Server struct {
	config     util.Config
	store      db.Store
	tokenMaker token.Maker
	router     *gin.Engine
}

func NewServer(config util.Config, store db.Store) (*Server, error) {
	tokenMaker, err := token.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("cannot create token maker: %w", err)
	}

	server := &Server{
		config:     config,
		store:      store,
		tokenMaker: tokenMaker,
	}

	server.setupRouter()

	return server, nil
}

func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

func (server *Server) setupRouter() {
	//account endpoint

	router := gin.Default()

	router.POST("/user", server.createUser)
	router.POST("/user/login", server.loginUser)
	router.POST("/tokens/renew_acces", server.renewAccesToken)
	authRoutes := router.Group("/").Use(authMiddleWare(server.tokenMaker))

	authRoutes.GET("/user/:username", server.getUser)
	authRoutes.POST("/accounts", server.createAccount)
	authRoutes.GET("/accounts/:id", server.getAccount)
	authRoutes.GET("/accounts", server.listAccount)
	//router.DELETE("accounts/delete", server.deleteAccount)

	//entries endpoint

	router.GET("/entry/:id", server.getEntry)
	router.GET("/entry", server.listEntry)

	//transfer endpoint
	router.POST("transfers", server.createTransfer)

	server.router = router
}

func errorResponse(err error) gin.H {
	return gin.H{"error": err.Error()}
}
