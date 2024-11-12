-- CreateEnum
CREATE TYPE "ActionType" AS ENUM ('USER_CREATE', 'USER_EDIT', 'USER_CHANGE_ROLE', 'USER_LOGIN', 'USER_LOGOUT', 'USER_DOWNLOAD_FILE', 'USER_LOGGED_INTO_BRIEFING_CONFERENCE', 'USER_LOGGED_INTO_AUDIT_CONFERENCE', 'USER_REQUEST_PASSWORD_RESET', 'USER_BLOCK_BY_LIMIT_LOGIN_ATTEMPTS', 'ADMIN_USER_PASSWORD_RESET', 'ADMIN_USER_BLOCK', 'ADMIN_USER_UNBLOCK', 'SYSTEM_MOVE_RESOURCES_TO_OPERATIVE_STORAGE_START', 'SYSTEM_MOVE_RESOURCES_TO_OPERATIVE_STORAGE_END', 'SYSTEM_MOVE_RESOURCES_FROM_OPERATIVE_TO_ARCHIVE_STORAGE_START', 'SYSTEM_MOVE_RESOURCES_FROM_OPERATIVE_TO_ARCHIVE_STORAGE_END', 'SOI_EVENT_CREATE', 'SOI_AUDIT_OPEN', 'SOI_AUDIT_CLOSE', 'SOI_BRIEFING_OPEN', 'SOI_BRIEFING_CLOSE', 'SOI_EVENT_PARTICIPANTS_CHANGE', 'SOI_CHECK_USERS');

-- CreateEnum
CREATE TYPE "ActionStatus" AS ENUM ('SUCCESS', 'ERROR');

-- CreateEnum
CREATE TYPE "SystemActionType" AS ENUM ('CREATE_EVENT', 'CREATE_INVENTORY');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('ACTIVE', 'BLOCKED');

-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'USER', 'TECHNOLOGY_OPERATOR', 'DEVELOPER', 'USER_ADMIN');

-- CreateEnum
CREATE TYPE "ParticipantRole" AS ENUM ('CHAIRMAN', 'PARTICIPANT', 'FINANCIALLY_RESPONSIBLE_PERSON', 'ACCOUNTANT', 'INSPECTOR', 'MANAGER', 'ACCOUNTANT_ACCEPTOR');

-- CreateEnum
CREATE TYPE "InventoryStatus" AS ENUM ('AVAILABLE', 'REMOVED', 'CLOSED');

-- CreateEnum
CREATE TYPE "EventStatus" AS ENUM ('ACTIVE', 'REMOVED');

-- CreateEnum
CREATE TYPE "BriefingStatus" AS ENUM ('NOT_STARTED', 'IN_PROGRESS', 'PASSED');

-- CreateEnum
CREATE TYPE "ResourceProcessStatus" AS ENUM ('NOT_PROCESSED', 'IN_PROCESS', 'PROCESSED');

-- CreateEnum
CREATE TYPE "ConferenseRole" AS ENUM ('SPEAKER', 'MODERATOR', 'ATTENDEE');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "passwordHashes" TEXT[],
    "role" "UserRole" NOT NULL DEFAULT 'USER',
    "status" "UserStatus" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "tabelNumber" TEXT NOT NULL,
    "ivaProfileId" TEXT,
    "refreshToken" TEXT,
    "ASOZSystemRequestNumber" TEXT,
    "lastUpdatePasswordDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isTemporaryPassword" BOOLEAN NOT NULL DEFAULT true,
    "divisionId" TEXT,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "events" (
    "id" TEXT NOT NULL,
    "commandId" TEXT NOT NULL,
    "commandNumber" TEXT NOT NULL,
    "commandDate" TIMESTAMP(3) NOT NULL,
    "orderId" TEXT NOT NULL,
    "orderNumber" TEXT NOT NULL,
    "orderDate" TIMESTAMP(3) NOT NULL,
    "startAt" TIMESTAMP(3) NOT NULL,
    "endAt" TIMESTAMP(3) NOT NULL,
    "balanceUnit" TEXT NOT NULL,
    "balanceUnitRegionCode" TEXT NOT NULL,
    "status" "EventStatus" NOT NULL DEFAULT 'ACTIVE',
    "briefingStatus" "BriefingStatus" NOT NULL DEFAULT 'NOT_STARTED',
    "briefingRoomInviteLink" TEXT,
    "briefingSessionId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "participants" (
    "id" TEXT NOT NULL,
    "eventId" TEXT NOT NULL,
    "inventoryId" TEXT,
    "tabelNumber" TEXT NOT NULL,
    "name" TEXT,
    "userId" TEXT,
    "role" "ParticipantRole" NOT NULL DEFAULT 'PARTICIPANT',

    CONSTRAINT "participants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "inventories" (
    "id" TEXT NOT NULL,
    "eventId" TEXT NOT NULL,
    "number" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "shortName" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "date" TIMESTAMP(3),
    "auditSessionId" TEXT,
    "auditRoomInviteLink" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "status" "InventoryStatus" NOT NULL DEFAULT 'AVAILABLE',
    "parentId" TEXT,
    "isProcessed" BOOLEAN NOT NULL DEFAULT false,
    "address" TEXT,
    "videographerId" TEXT,
    "inspectorId" TEXT,

    CONSTRAINT "inventories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "inventory_locations" (
    "id" TEXT NOT NULL,
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "dateTime" TIMESTAMPTZ NOT NULL,
    "accuracy" DOUBLE PRECISION NOT NULL,
    "inventoryId" TEXT NOT NULL,
    "resourceId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" TEXT,

    CONSTRAINT "inventory_locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "inventory_objects" (
    "id" TEXT NOT NULL,
    "inventoryId" TEXT NOT NULL,
    "inventoryNumber" TEXT,
    "location" TEXT,
    "serialNumber" TEXT,
    "networkNumber" TEXT,
    "passportNumber" TEXT,
    "quantity" INTEGER,
    "state" TEXT,
    "name" TEXT,
    "unitCode" TEXT,
    "unitName" TEXT,
    "batchNumber" TEXT,
    "placement" TEXT,
    "nomenclatureNumber" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "onVideoAt" TIMESTAMPTZ,
    "isConditionOk" BOOLEAN,
    "comments" TEXT,

    CONSTRAINT "inventory_objects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "inventory_resources" (
    "id" TEXT NOT NULL,
    "ivaId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "startAt" TIMESTAMPTZ,
    "endAt" TIMESTAMPTZ,
    "inventoryId" TEXT NOT NULL,
    "url" TEXT,
    "s3Url" TEXT,
    "s3MetadataUrl" TEXT,
    "metadataPath" TEXT,
    "videoHash" TEXT,
    "metadataHash" TEXT,
    "status" "ResourceProcessStatus" NOT NULL DEFAULT 'NOT_PROCESSED',
    "duration" DOUBLE PRECISION,
    "isArchived" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "inventory_resources_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "actions" (
    "id" TEXT NOT NULL,
    "requestId" TEXT,
    "actionAt" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "type" "ActionType" NOT NULL,
    "status" "ActionStatus" NOT NULL,
    "initiator" TEXT NOT NULL,
    "ip" TEXT,
    "details" JSONB,

    CONSTRAINT "actions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "division_hierarchies" (
    "id" TEXT NOT NULL,
    "hierId" TEXT NOT NULL,
    "sessionId" TEXT NOT NULL,
    "parts" INTEGER NOT NULL,
    "titleSh" TEXT NOT NULL,
    "titleMd" TEXT NOT NULL,
    "titleLn" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "division_hierarchies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "division_hierarchies_nodes" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "parentId" TEXT NOT NULL,
    "from" TIMESTAMPTZ NOT NULL,
    "to" TIMESTAMPTZ NOT NULL,
    "level" INTEGER NOT NULL,
    "divType" TEXT NOT NULL,
    "titleSh" TEXT NOT NULL,
    "titleMd" TEXT NOT NULL,
    "titleLn" TEXT NOT NULL,
    "bukrs" TEXT NOT NULL,
    "divisionHierarchyId" TEXT NOT NULL,

    CONSTRAINT "division_hierarchies_nodes_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_tabelNumber_key" ON "users"("tabelNumber");

-- CreateIndex
CREATE UNIQUE INDEX "users_ivaProfileId_key" ON "users"("ivaProfileId");

-- CreateIndex
CREATE UNIQUE INDEX "participants_eventId_inventoryId_tabelNumber_key" ON "participants"("eventId", "inventoryId", "tabelNumber");

-- CreateIndex
CREATE UNIQUE INDEX "inventory_resources_name_inventoryId_ivaId_key" ON "inventory_resources"("name", "inventoryId", "ivaId");

-- AddForeignKey
ALTER TABLE "participants" ADD CONSTRAINT "participants_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "participants" ADD CONSTRAINT "participants_inventoryId_fkey" FOREIGN KEY ("inventoryId") REFERENCES "inventories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "participants" ADD CONSTRAINT "participants_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventories" ADD CONSTRAINT "inventories_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventories" ADD CONSTRAINT "inventories_videographerId_fkey" FOREIGN KEY ("videographerId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory_locations" ADD CONSTRAINT "inventory_locations_inventoryId_fkey" FOREIGN KEY ("inventoryId") REFERENCES "inventories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory_locations" ADD CONSTRAINT "inventory_locations_resourceId_fkey" FOREIGN KEY ("resourceId") REFERENCES "inventory_resources"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory_locations" ADD CONSTRAINT "inventory_locations_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory_objects" ADD CONSTRAINT "inventory_objects_inventoryId_fkey" FOREIGN KEY ("inventoryId") REFERENCES "inventories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory_resources" ADD CONSTRAINT "inventory_resources_inventoryId_fkey" FOREIGN KEY ("inventoryId") REFERENCES "inventories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "division_hierarchies_nodes" ADD CONSTRAINT "division_hierarchies_nodes_divisionHierarchyId_fkey" FOREIGN KEY ("divisionHierarchyId") REFERENCES "division_hierarchies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
