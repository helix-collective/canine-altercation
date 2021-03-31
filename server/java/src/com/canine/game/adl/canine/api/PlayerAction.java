/* @generated from adl module canine.api */

package com.canine.game.adl.canine.api;

import com.google.gson.JsonElement;
import org.adl.runtime.Factories;
import org.adl.runtime.Factory;
import org.adl.runtime.JsonBinding;
import org.adl.runtime.JsonBindings;
import org.adl.runtime.JsonParseException;
import org.adl.runtime.Lazy;
import org.adl.runtime.sys.adlast.ScopedName;
import org.adl.runtime.sys.adlast.TypeExpr;
import org.adl.runtime.sys.adlast.TypeRef;
import java.util.ArrayList;
import java.util.Objects;

public class PlayerAction {

  /* Members */

  private Disc disc;
  private Object value;

  /**
   * The PlayerAction discriminator type.
   */
  public enum Disc {
    THRUST,
    FIRE,
    ROTATELEFT,
    ROTATERIGHT
  }

  /* Constructors */

  public static PlayerAction thrust(Duration v) {
    return new PlayerAction(Disc.THRUST, Objects.requireNonNull(v));
  }

  public static PlayerAction fire() {
    return new PlayerAction(Disc.FIRE, null);
  }

  public static PlayerAction rotateLeft(Angle v) {
    return new PlayerAction(Disc.ROTATELEFT, Objects.requireNonNull(v));
  }

  public static PlayerAction rotateRight(Angle v) {
    return new PlayerAction(Disc.ROTATERIGHT, Objects.requireNonNull(v));
  }

  public PlayerAction() {
    this.disc = Disc.THRUST;
    this.value = new Duration();
  }

  public PlayerAction(PlayerAction other) {
    this.disc = other.disc;
    switch (other.disc) {
      case THRUST:
        this.value = Duration.FACTORY.create((Duration) other.value);
        break;
      case FIRE:
        this.value = (Void) other.value;
        break;
      case ROTATELEFT:
        this.value = Angle.FACTORY.create((Angle) other.value);
        break;
      case ROTATERIGHT:
        this.value = Angle.FACTORY.create((Angle) other.value);
        break;
    }
  }

  private PlayerAction(Disc disc, Object value) {
    this.disc = disc;
    this.value = value;
  }

  /* Accessors */

  public Disc getDisc() {
    return disc;
  }

  public Duration getThrust() {
    if (disc == Disc.THRUST) {
      return (Duration) value;
    }
    throw new IllegalStateException();
  }

  public Angle getRotateLeft() {
    if (disc == Disc.ROTATELEFT) {
      return (Angle) value;
    }
    throw new IllegalStateException();
  }

  public Angle getRotateRight() {
    if (disc == Disc.ROTATERIGHT) {
      return (Angle) value;
    }
    throw new IllegalStateException();
  }

  /* Mutators */

  public void setThrust(Duration v) {
    this.value = Objects.requireNonNull(v);
    this.disc = Disc.THRUST;
  }

  public void setFire() {
    this.value = null;
    this.disc = Disc.FIRE;
  }

  public void setRotateLeft(Angle v) {
    this.value = Objects.requireNonNull(v);
    this.disc = Disc.ROTATELEFT;
  }

  public void setRotateRight(Angle v) {
    this.value = Objects.requireNonNull(v);
    this.disc = Disc.ROTATERIGHT;
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other0) {
    if (!(other0 instanceof PlayerAction)) {
      return false;
    }
    PlayerAction other = (PlayerAction) other0;
    switch (disc) {
      case THRUST:
        return disc == other.disc && value.equals(other.value);
      case FIRE:
        return disc == other.disc;
      case ROTATELEFT:
        return disc == other.disc && value.equals(other.value);
      case ROTATERIGHT:
        return disc == other.disc && value.equals(other.value);
    }
    throw new IllegalStateException();
  }

  @Override
  public int hashCode() {
    switch (disc) {
      case THRUST:
        return disc.hashCode() * 37 + value.hashCode();
      case FIRE:
        return disc.hashCode();
      case ROTATELEFT:
        return disc.hashCode() * 37 + value.hashCode();
      case ROTATERIGHT:
        return disc.hashCode() * 37 + value.hashCode();
    }
    throw new IllegalStateException();
  }

  /* Factory for construction of generic values */

  public static final Factory<PlayerAction> FACTORY = new Factory<PlayerAction>() {
    @Override
    public PlayerAction create() {
      return new PlayerAction();
    }

    @Override
    public PlayerAction create(PlayerAction other) {
      return new PlayerAction(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "PlayerAction");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }

    @Override
    public JsonBinding<PlayerAction> jsonBinding() {
      return PlayerAction.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<PlayerAction> jsonBinding() {
    final Lazy<JsonBinding<Duration>> thrust = new Lazy<>(() -> Duration.jsonBinding());
    final Lazy<JsonBinding<Void>> fire = new Lazy<>(() -> JsonBindings.VOID);
    final Lazy<JsonBinding<Angle>> rotateLeft = new Lazy<>(() -> Angle.jsonBinding());
    final Lazy<JsonBinding<Angle>> rotateRight = new Lazy<>(() -> Angle.jsonBinding());
    final Factory<PlayerAction> _factory = FACTORY;

    return new JsonBinding<PlayerAction>() {
      @Override
      public Factory<PlayerAction> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(PlayerAction _value) {
        switch (_value.getDisc()) {
          case THRUST:
            return JsonBindings.unionToJson("thrust", _value.getThrust(), thrust.get());
          case FIRE:
            return JsonBindings.unionToJson("fire", null, null);
          case ROTATELEFT:
            return JsonBindings.unionToJson("rotateLeft", _value.getRotateLeft(), rotateLeft.get());
          case ROTATERIGHT:
            return JsonBindings.unionToJson("rotateRight", _value.getRotateRight(), rotateRight.get());
        }
        return null;
      }

      @Override
      public PlayerAction fromJson(JsonElement _json) {
        String _key = JsonBindings.unionNameFromJson(_json);
        if (_key.equals("thrust")) {
          return PlayerAction.thrust(JsonBindings.unionValueFromJson(_json, thrust.get()));
        }
        else if (_key.equals("fire")) {
          return PlayerAction.fire();
        }
        else if (_key.equals("rotateLeft")) {
          return PlayerAction.rotateLeft(JsonBindings.unionValueFromJson(_json, rotateLeft.get()));
        }
        else if (_key.equals("rotateRight")) {
          return PlayerAction.rotateRight(JsonBindings.unionValueFromJson(_json, rotateRight.get()));
        }
        throw new JsonParseException("Invalid discriminator " + _key + " for union PlayerAction");
      }
    };
  }
}
